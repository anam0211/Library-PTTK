package vn.edu.library.dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.List;
import org.junit.jupiter.api.Test;
import vn.edu.library.db.ConnectionFactory;
import vn.edu.library.model.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

class LoanSlipDAOTest {
    @Test void validatesNoteLengthWithoutTruncatingVietnamese() throws Exception {
        LoanSlipDAO.validateInspection("Hư hỏng nhẹ", "á".repeat(255));
        assertThrows(LoanValidationException.class, () -> LoanSlipDAO.validateInspection("Tốt", "á".repeat(256)));
        assertThrows(LoanValidationException.class, () -> LoanSlipDAO.validateInspection(" ", ""));
    }

    @Test void rollsBackHeaderAndFirstDetailWhenSecondDetailFails() throws Exception {
        assumeTrue("true".equalsIgnoreCase(System.getenv("LIBMAN_DB_INTEGRATION")));
        try (Connection connection = ConnectionFactory.fromEnvironment().openConnection()) {
            ReaderDAO readers = new ReaderDAO(connection);
            Reader2 reader = readers.searchReader("BD0017").get(0);
            LibraryCard2 card = readers.getUsableCard(reader.getId(), BorrowingContext.today());
            BorrowingPolicy2 policy = readers.getApplicablePolicy(reader.getId(), BorrowingContext.today());
            List<DocumentCopy2> candidates = new DocumentCopyDAO(connection).getCopiesByTitle(
                    new DocumentTitleDAO(connection).searchByName("Cơ sở dữ liệu").get(0).getId())
                    .stream().filter(DocumentCopy2::isAvailable).limit(2).toList();
            assumeTrue(candidates.size() == 2 && readers.getCurrentLoanDetails(reader.getId()).size() + 2 <= policy.getMaximumCopies());
            int beforeSlips = count(connection, "tblLoanSlip"), beforeDetails = count(connection, "tblLoanDetail");
            LoanSlipDAO failing = new LoanSlipDAO(connection) {
                private int calls;
                @Override public void saveLoanDetail(int loanId, LoanDetail2 detail) throws SQLException {
                    super.saveLoanDetail(loanId, detail);
                    if (++calls == 2) throw new SQLException("Injected second-detail failure", "45000");
                }
            };
            assertThrows(SQLException.class, () -> failing.saveLoan(card, policy, readers.getLibrarian("NV001"),
                    candidates.stream().map(c -> c.withInspection("Tốt", "ROLLBACK-TEST")).toArray(DocumentCopy2[]::new)));
            assertEquals(beforeSlips, count(connection, "tblLoanSlip"));
            assertEquals(beforeDetails, count(connection, "tblLoanDetail"));
            for (DocumentCopy2 copy : candidates) assertTrue(new DocumentCopyDAO(connection).findByCode(copy.getCopyCode()).isAvailable());
            assertTrue(connection.getAutoCommit());
        }
    }

    @Test void expiredCardAndConfiguredDebtRestrictionAreRejected() {
        LocalDate today = BorrowingContext.today();
        Reader2 reader = new Reader2(1, "BD", "Tên", "Hoạt động");
        LibraryCard2 card = new LibraryCard2(1, 1, "TD", today.minusYears(1), today.plusYears(1), "Hoạt động");
        BorrowingPolicy2 policy = new BorrowingPolicy2(1, 5, 14, "Ngày mượn + thời hạn", "BLOCK_UNPAID_FINE");
        BorrowingContext debt = new BorrowingContext(reader, card, policy, List.of(), new java.math.BigDecimal("5000"), today);
        assertFalse(debt.isEligible());
        assertTrue(debt.getError().contains("phạt"));
        BorrowingContext expired = new BorrowingContext(reader,
                new LibraryCard2(1, 1, "TD", today.minusYears(2), today.minusDays(1), "Hoạt động"),
                policy, List.of(), java.math.BigDecimal.ZERO, today);
        assertFalse(expired.isEligible());
        assertEquals(today.plusDays(14), policy.dueDate(today));
    }

    @Test void staleSelectionOfBorrowedCopyDoesNotCreateAnyPartialLoan() throws Exception {
        assumeTrue("true".equalsIgnoreCase(System.getenv("LIBMAN_DB_INTEGRATION")));
        try (Connection connection = ConnectionFactory.fromEnvironment().openConnection()) {
            ReaderDAO readers = new ReaderDAO(connection);
            Reader2 reader = readers.searchReader("BD0017").get(0);
            LibraryCard2 card = readers.getUsableCard(reader.getId(), BorrowingContext.today());
            BorrowingPolicy2 policy = readers.getApplicablePolicy(reader.getId(), BorrowingContext.today());
            assumeTrue(card != null && readers.getCurrentLoanDetails(reader.getId()).size() < policy.getMaximumCopies());
            String borrowedCode;
            try (Statement statement = connection.createStatement(); ResultSet rows = statement.executeQuery(
                    "SELECT copyCode FROM tblDocumentCopy WHERE copyStatus <> 'Sẵn sàng' AND usageType = 'Mượn về' ORDER BY id LIMIT 1")) {
                assumeTrue(rows.next()); borrowedCode = rows.getString(1);
            }
            DocumentCopy2 stale = new DocumentCopyDAO(connection).findByCode(borrowedCode).withInspection("Tốt", "STALE-SELECTION-TEST");
            int beforeSlips = count(connection, "tblLoanSlip"), beforeDetails = count(connection, "tblLoanDetail");
            LoanValidationException failure = assertThrows(LoanValidationException.class, () -> new LoanSlipDAO(connection)
                    .saveLoan(card, policy, readers.getLibrarian("NV001"), new DocumentCopy2[] {stale}));
            assertTrue(failure.getMessage().contains("không còn sẵn sàng"));
            assertEquals(beforeSlips, count(connection, "tblLoanSlip"));
            assertEquals(beforeDetails, count(connection, "tblLoanDetail"));
        }
    }

    private static int count(Connection con, String table) throws SQLException {
        try (Statement statement = con.createStatement(); ResultSet rows = statement.executeQuery("SELECT COUNT(*) FROM " + table)) {
            rows.next(); return rows.getInt(1);
        }
    }
}
