package vn.edu.library.dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import vn.edu.library.model.*;

public class LoanSlipDAO extends DAO {
    public LoanSlipDAO() throws SQLException { super(); }
    public LoanSlipDAO(Connection con) { super(con); }

    /** Exact report signature. All nested DAOs use this con; this method owns commit/rollback. */
    public LoanSlip2 saveLoan(LibraryCard2 lc, BorrowingPolicy2 bp, Librarian2 lr,
                              DocumentCopy2[] selectedCopies) throws SQLException, LoanValidationException {
        if (!con.getAutoCommit()) throw new SQLException("saveLoan cần kết nối chưa mở giao dịch.");
        int previousIsolation = con.getTransactionIsolation();
        con.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
        con.setAutoCommit(false);
        try {
            if (lc == null || bp == null || lr == null) throw new LoanValidationException("Thiếu thẻ, quy định hoặc nhân viên cho mượn.");
            ReaderDAO readers = new ReaderDAO(con);
            int readerId = readers.lockReaderForCard(lc.getId());
            LocalDate today = BorrowingContext.today();
            LibraryCard2 card = readers.getUsableCard(readerId, today);
            BorrowingPolicy2 policy = readers.getApplicablePolicy(readerId, today);
            BorrowingContext context = new BorrowingContext(readers.getById(readerId), card, policy,
                    readers.getCurrentLoanDetails(readerId), readers.getUnpaidFineAmount(readerId), today);
            if (!context.isEligible()) throw new LoanValidationException(context.getError());
            if (card.getId() != lc.getId() || policy.getId() != bp.getId())
                throw new LoanValidationException("Thẻ hoặc quy định vừa thay đổi. Kiểm tra lại thông tin bạn đọc.");
            Librarian2 staff = readers.getLibrarian(lr.getCode());
            if (staff == null || staff.getId() != lr.getId()) throw new LoanValidationException("Nhân viên không được phép cho mượn.");
            if (selectedCopies == null || selectedCopies.length == 0) throw new LoanValidationException("Chọn ít nhất một bản tài liệu.");
            if (selectedCopies.length > context.getRemaining()) throw new LoanValidationException("Danh sách vượt hạn mức còn lại của bạn đọc.");

            // Stable lock order prevents two sessions from locking the same copies in opposite order.
            TreeMap<String, DocumentCopy2> selected = new TreeMap<>();
            for (DocumentCopy2 copy : selectedCopies) {
                if (copy == null || copy.getCopyCode() == null) throw new LoanValidationException("Bản tài liệu không hợp lệ.");
                String code = copy.getCopyCode().toUpperCase(Locale.ROOT);
                if (selected.put(code, copy) != null) throw new LoanValidationException("Một bản chỉ được có một lần trong phiếu.");
                validateInspection(copy.getPhysicalCondition(), copy.getNote());
            }
            DocumentCopyDAO copies = new DocumentCopyDAO(con);
            for (String code : selected.keySet()) {
                DocumentCopy2 current = copies.lockByCode(code);
                if (current == null || !current.isAvailable())
                    throw new LoanValidationException("Bản " + code + " không còn sẵn sàng để mượn về. Hãy loại bỏ hoặc chọn bản khác.");
            }

            String number = "PM-" + UUID.randomUUID().toString().toUpperCase(Locale.ROOT);
            int loanId;
            try (PreparedStatement statement = con.prepareStatement("""
                    INSERT INTO tblLoanSlip (slipNumber, borrowedAt, status, libraryCardId, borrowingPolicyId, librarianId)
                    VALUES (?, CURRENT_TIMESTAMP, 'Đang mượn', ?, ?, ?)
                    """, Statement.RETURN_GENERATED_KEYS)) {
                statement.setString(1, number); statement.setInt(2, card.getId());
                statement.setInt(3, policy.getId()); statement.setInt(4, staff.getId());
                statement.executeUpdate();
                try (ResultSet keys = statement.getGeneratedKeys()) { keys.next(); loanId = keys.getInt(1); }
            }
            for (DocumentCopy2 copy : selectedCopies) {
                saveLoanDetail(loanId, new LoanDetail2(0, copy, policy.dueDate(today), copy.getPhysicalCondition(), copy.getNote()));
            }
            String[] codes = Arrays.stream(selectedCopies).map(DocumentCopy2::getCopyCode).toArray(String[]::new);
            String[] conditions = Arrays.stream(selectedCopies).map(DocumentCopy2::getPhysicalCondition).toArray(String[]::new);
            if (!copies.markAsBorrowed(codes, conditions)) throw new LoanValidationException("Trạng thái bản vừa thay đổi. Phiếu chưa được lưu.");
            LoanSlip2 saved = getById(loanId);
            con.commit();
            return saved;
        } catch (SQLException | LoanValidationException | RuntimeException exception) {
            try { con.rollback(); } catch (SQLException rollbackError) { exception.addSuppressed(rollbackError); }
            throw exception;
        } finally {
            con.setAutoCommit(true);
            con.setTransactionIsolation(previousIsolation);
        }
    }

    public static void validateInspection(String condition, String note) throws LoanValidationException {
        if (condition == null || condition.isBlank() || condition.length() > 255)
            throw new LoanValidationException("Chọn tình trạng lúc mượn hợp lệ (tối đa 255 ký tự).");
        if (note != null && note.length() > 255)
            throw new LoanValidationException("Ghi chú tình trạng tối đa 255 ký tự theo CSDL.");
    }

    public void saveLoanDetail(int loanId, LoanDetail2 detail) throws SQLException {
        if (con.getAutoCommit()) throw new SQLException("saveLoanDetail cần cùng giao dịch với phiếu.");
        try (PreparedStatement statement = con.prepareStatement("""
                INSERT INTO tblLoanDetail (dueDate, conditionAtLoan, loanStatus, note, documentCopyId, loanSlipId)
                VALUES (?, ?, 'Đang mượn', ?, ?, ?)
                """)) {
            statement.setObject(1, detail.getDueDate()); statement.setString(2, detail.getConditionAtLoan());
            statement.setString(3, detail.getNote()); statement.setInt(4, detail.getDocumentCopy().getId()); statement.setInt(5, loanId);
            statement.executeUpdate();
        }
    }

    public LoanSlip2 getById(int loanId) throws SQLException {
        String number;
        java.time.Instant borrowedAt;
        Reader2 reader;
        LibraryCard2 card;
        Librarian2 staff;
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT l.slipNumber, l.borrowedAt, c.id AS cardId, c.cardNumber, c.issuedAt, c.expiresAt, c.status AS cardStatus,
                       r.memberId, r.readerCode, r.readerStatus, rm.fullName AS readerName,
                       sm.id AS staffId, sm.username, sm.fullName AS staffName
                FROM tblLoanSlip l JOIN tblLibraryCard c ON c.id = l.libraryCardId
                JOIN tblCardApplication a ON a.id = c.cardApplicationId JOIN tblReader r ON r.memberId = a.readerId
                JOIN tblMember rm ON rm.id = r.memberId JOIN tblMember sm ON sm.id = l.librarianId
                WHERE l.id = ?
                """)) {
            statement.setInt(1, loanId);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) return null;
                number = rows.getString("slipNumber"); borrowedAt = rows.getTimestamp("borrowedAt").toInstant();
                reader = new Reader2(rows.getInt("memberId"), rows.getString("readerCode"), rows.getString("readerName"), rows.getString("readerStatus"));
                card = new LibraryCard2(rows.getInt("cardId"), reader.getId(), rows.getString("cardNumber"),
                        rows.getObject("issuedAt", LocalDate.class), rows.getObject("expiresAt", LocalDate.class), rows.getString("cardStatus"));
                staff = new Librarian2(rows.getInt("staffId"), rows.getString("username"), rows.getString("staffName"));
            }
        }
        List<LoanDetail2> details = new ArrayList<>();
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT c.*, t.titleName, CONCAT_WS('-', s.area, s.shelf, s.compartment) AS location,
                       ld.id AS detailId, ld.dueDate, ld.conditionAtLoan, ld.note AS detailNote
                FROM tblLoanDetail ld JOIN tblDocumentCopy c ON c.id = ld.documentCopyId
                JOIN tblDocumentTitle t ON t.id = c.documentTitleId
                LEFT JOIN tblStorageLocation s ON s.id = c.storageLocationId
                WHERE ld.loanSlipId = ? ORDER BY ld.id
                """)) {
            statement.setInt(1, loanId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) details.add(new LoanDetail2(rows.getInt("detailId"), DocumentCopyDAO.map(rows),
                        rows.getObject("dueDate", LocalDate.class), rows.getString("conditionAtLoan"), rows.getString("detailNote")));
            }
        }
        return new LoanSlip2(loanId, number, borrowedAt, reader, card, staff, details);
    }
}
