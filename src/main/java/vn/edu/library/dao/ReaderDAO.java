package vn.edu.library.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import vn.edu.library.model.*;

public class ReaderDAO extends DAO {
    public ReaderDAO() throws SQLException { super(); }
    public ReaderDAO(Connection con) { super(con); }

    public List<Reader2> searchReader(String keyword) throws SQLException {
        List<Reader2> result = new ArrayList<>();
        if (keyword == null || keyword.isBlank()) return result;
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT r.memberId, r.readerCode, r.readerStatus, m.fullName
                FROM tblReader r JOIN tblMember m ON m.id = r.memberId
                WHERE r.readerCode LIKE ? ESCAPE '!' OR m.fullName LIKE ? ESCAPE '!'
                  OR EXISTS (SELECT 1 FROM tblCardApplication a JOIN tblLibraryCard c ON c.cardApplicationId = a.id
                             WHERE a.readerId = r.memberId AND c.cardNumber LIKE ? ESCAPE '!')
                ORDER BY r.readerCode
                """)) {
            for (int i = 1; i <= 3; i++) statement.setString(i, keyword(keyword));
            try (ResultSet rows = statement.executeQuery()) { while (rows.next()) result.add(mapReader(rows)); }
        }
        return result;
    }

    public Reader2 getById(int readerId) throws SQLException {
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT r.memberId, r.readerCode, r.readerStatus, m.fullName
                FROM tblReader r JOIN tblMember m ON m.id = r.memberId WHERE r.memberId = ?
                """)) {
            statement.setInt(1, readerId);
            try (ResultSet rows = statement.executeQuery()) { return rows.next() ? mapReader(rows) : null; }
        }
    }

    public LibraryCard2 getUsableCard(int readerId, LocalDate borrowDate) throws SQLException {
        return card(readerId, borrowDate, true);
    }

    public LibraryCard2 getLatestCard(int readerId) throws SQLException { return card(readerId, LocalDate.now(), false); }

    private LibraryCard2 card(int readerId, LocalDate date, boolean usable) throws SQLException {
        String sql = """
                SELECT c.*, a.readerId FROM tblLibraryCard c
                JOIN tblCardApplication a ON a.id = c.cardApplicationId WHERE a.readerId = ?
                """ + (usable ? " AND c.status = 'Hoạt động' AND c.issuedAt <= ? AND c.expiresAt >= ?" : "")
                + " ORDER BY c.issuedAt DESC, c.id DESC LIMIT 1";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, readerId);
            if (usable) { statement.setObject(2, date); statement.setObject(3, date); }
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? new LibraryCard2(rows.getInt("id"), readerId, rows.getString("cardNumber"),
                        rows.getObject("issuedAt", LocalDate.class), rows.getObject("expiresAt", LocalDate.class), rows.getString("status")) : null;
            }
        }
    }

    public BorrowingPolicy2 getApplicablePolicy(int readerId, LocalDate borrowDate) throws SQLException {
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT p.* FROM tblBorrowingPolicy p JOIN tblReader r ON r.readerGroup = p.readerGroup
                WHERE r.memberId = ? AND p.effectiveFrom <= ? AND (p.effectiveTo IS NULL OR p.effectiveTo >= ?)
                ORDER BY p.effectiveFrom DESC, p.id DESC LIMIT 1
                """ + (con.getAutoCommit() ? "" : " FOR SHARE"))) {
            statement.setInt(1, readerId); statement.setObject(2, borrowDate); statement.setObject(3, borrowDate);
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? new BorrowingPolicy2(rows.getInt("id"), rows.getInt("maximumCopies"),
                        rows.getInt("loanPeriodDays"), rows.getString("dueDateRule"), rows.getString("borrowingRestriction")) : null;
            }
        }
    }

    public List<LoanDetail2> getCurrentLoanDetails(int readerId) throws SQLException {
        List<LoanDetail2> result = new ArrayList<>();
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT c.*, t.titleName, CONCAT_WS('-', s.area, s.shelf, s.compartment) AS location,
                       ld.id AS detailId, ld.dueDate, ld.conditionAtLoan, ld.note AS detailNote
                FROM tblLoanDetail ld JOIN tblLoanSlip l ON l.id = ld.loanSlipId
                JOIN tblLibraryCard card ON card.id = l.libraryCardId
                JOIN tblCardApplication a ON a.id = card.cardApplicationId
                JOIN tblDocumentCopy c ON c.id = ld.documentCopyId
                JOIN tblDocumentTitle t ON t.id = c.documentTitleId
                LEFT JOIN tblStorageLocation s ON s.id = c.storageLocationId
                WHERE a.readerId = ? AND ld.returnedAt IS NULL
                  AND ld.loanStatus NOT IN ('Đã trả', 'Đã xử lý mất', 'Đã hoàn tất xử lý mất')
                ORDER BY ld.id
                """)) {
            statement.setInt(1, readerId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) result.add(new LoanDetail2(rows.getInt("detailId"), DocumentCopyDAO.map(rows),
                        rows.getObject("dueDate", LocalDate.class), rows.getString("conditionAtLoan"), rows.getString("detailNote")));
            }
        }
        return result;
    }

    public BigDecimal getUnpaidFineAmount(int readerId) throws SQLException {
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT COALESCE(SUM(f.fineAmount), 0) FROM tblFineSlip f
                JOIN tblLoanDetail ld ON ld.id = f.loanDetailId JOIN tblLoanSlip l ON l.id = ld.loanSlipId
                JOIN tblLibraryCard c ON c.id = l.libraryCardId JOIN tblCardApplication a ON a.id = c.cardApplicationId
                WHERE a.readerId = ? AND f.cancelledAt IS NULL AND f.status <> 'Đã hủy'
                  AND NOT EXISTS (SELECT 1 FROM tblFinePaymentReceipt p WHERE p.fineSlipId = f.id)
                """)) {
            statement.setInt(1, readerId);
            try (ResultSet rows = statement.executeQuery()) { rows.next(); return rows.getBigDecimal(1); }
        }
    }

    public Librarian2 getLibrarian(String code) throws SQLException {
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT m.id, m.username, m.fullName FROM tblMember m JOIN tblStaff s ON s.memberId = m.id
                WHERE m.username = ? AND m.role = 'Librarian' AND s.employmentStatus = 'Đang làm việc'
                """)) {
            statement.setString(1, code);
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? new Librarian2(rows.getInt("id"), rows.getString("username"), rows.getString("fullName")) : null;
            }
        }
    }

    /** Serialize all confirmations for the same reader, including confirmations from other sessions. */
    int lockReaderForCard(int cardId) throws SQLException {
        int readerId;
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT memberId FROM tblReader WHERE memberId = (
                  SELECT a.readerId FROM tblCardApplication a JOIN tblLibraryCard c ON c.cardApplicationId = a.id
                  WHERE c.id = ?) FOR UPDATE
                """)) {
            statement.setInt(1, cardId);
            try (ResultSet rows = statement.executeQuery()) { readerId = rows.next() ? rows.getInt(1) : 0; }
        }
        try (PreparedStatement statement = con.prepareStatement("SELECT id FROM tblLibraryCard WHERE id = ? FOR UPDATE")) {
            statement.setInt(1, cardId);
            try (ResultSet rows = statement.executeQuery()) { if (!rows.next()) return 0; }
        }
        return readerId;
    }

    static Reader2 mapReader(ResultSet rows) throws SQLException {
        return new Reader2(rows.getInt("memberId"), rows.getString("readerCode"), rows.getString("fullName"), rows.getString("readerStatus"));
    }
}
