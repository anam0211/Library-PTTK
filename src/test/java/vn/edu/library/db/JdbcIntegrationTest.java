package vn.edu.library.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/** Opt in with LIBMAN_DB_INTEGRATION=true after seeding a test database. All writes roll back. */
class JdbcIntegrationTest {
    @Test
    void realMysqlSupportsMultipleDetailsAndRepeatedLoansAndRejectsConflictingLinks() throws Exception {
        assumeTrue("true".equalsIgnoreCase(System.getenv("LIBMAN_DB_INTEGRATION")),
                "Requires an explicitly configured, seeded MySQL test database.");
        try (Connection connection = ConnectionFactory.fromEnvironment().openConnection()) {
            JdbcSmokeCheck.verify(connection);
            int before = scalar(connection, "SELECT COUNT(*) FROM tblLoanDetail");
            connection.setAutoCommit(false);
            try {
                int copy1 = scalar(connection, "SELECT id FROM tblDocumentCopy WHERE copyStatus = 'Sẵn sàng' AND usageType = 'Mượn về' ORDER BY id LIMIT 1");
                int copy2 = scalar(connection, "SELECT id FROM tblDocumentCopy WHERE copyStatus = 'Sẵn sàng' AND usageType = 'Mượn về' AND documentTitleId <> (SELECT documentTitleId FROM tblDocumentCopy WHERE id = " + copy1 + ") ORDER BY id LIMIT 1");
                int title2 = scalar(connection, "SELECT documentTitleId FROM tblDocumentCopy WHERE id = " + copy2);
                int slip1 = insertSlip(connection);
                int slip2 = insertSlip(connection);
                insertDetail(connection, slip1, copy1);
                insertDetail(connection, slip1, copy2);
                assertEquals(2, scalar(connection, "SELECT COUNT(*) FROM tblLoanDetail WHERE loanSlipId = " + slip1));
                // The same unfinished copy cannot be lent on a second slip.
                assertIntegrityViolation(() -> insertDetail(connection, slip2, copy1));
                try (PreparedStatement statement = connection.prepareStatement(
                        "UPDATE tblLoanDetail SET returnedAt = CURRENT_TIMESTAMP, conditionAtReturn = 'Tốt', "
                                + "loanStatus = 'Đã trả' WHERE loanSlipId = ? AND documentCopyId = ?")) {
                    statement.setInt(1, slip1);
                    statement.setInt(2, copy1);
                    assertEquals(1, statement.executeUpdate());
                }
                insertDetail(connection, slip2, copy1);
                assertEquals(2, scalar(connection, "SELECT COUNT(*) FROM tblLoanDetail WHERE documentCopyId = " + copy1));
                // Even after return, a copy cannot be duplicated inside its original slip.
                assertIntegrityViolation(() -> insertDetail(connection, slip1, copy1));
                // Receipt line and copy must refer to the same document title.
                assertIntegrityViolation(() -> {
                    try (PreparedStatement statement = connection.prepareStatement(
                            "UPDATE tblDocumentCopy SET documentTitleId = ? WHERE id = ?")) {
                        statement.setInt(1, title2);
                        statement.setInt(2, copy1);
                        statement.executeUpdate();
                    }
                });
                assertIntegrityViolation(() -> insertDetail(connection, slip2, -1));
            } finally {
                connection.rollback();
            }
            assertEquals(before, scalar(connection, "SELECT COUNT(*) FROM tblLoanDetail"));
        }
    }

    private static int insertSlip(Connection connection) throws SQLException {
        String sql = """
                INSERT INTO tblLoanSlip (slipNumber, borrowedAt, status, libraryCardId, borrowingPolicyId, librarianId)
                SELECT ?, CURRENT_TIMESTAMP, 'Đang mượn', c.id, p.id, s.memberId
                FROM tblLibraryCard c CROSS JOIN tblBorrowingPolicy p CROSS JOIN tblStaff s
                WHERE c.cardNumber = 'TD017' ORDER BY p.id, s.memberId LIMIT 1
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, "JDBC-TEST-" + UUID.randomUUID());
            assertEquals(1, statement.executeUpdate());
            try (ResultSet keys = statement.getGeneratedKeys()) {
                assertTrue(keys.next());
                return keys.getInt(1);
            }
        }
    }

    private static void insertDetail(Connection connection, int slip, int copy) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "INSERT INTO tblLoanDetail (dueDate, conditionAtLoan, loanStatus, documentCopyId, loanSlipId) "
                        + "VALUES (DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), 'Tốt', 'Đang mượn', ?, ?)")) {
            statement.setInt(1, copy);
            statement.setInt(2, slip);
            statement.executeUpdate();
        }
    }

    private static int scalar(Connection connection, String sql) throws SQLException {
        try (Statement statement = connection.createStatement(); ResultSet rows = statement.executeQuery(sql)) {
            assertTrue(rows.next());
            return rows.getInt(1);
        }
    }

    private static void assertIntegrityViolation(SqlAction action) {
        SQLException error = assertThrows(SQLException.class, action::run);
        assertTrue(error.getSQLState().startsWith("23"), "Expected a constraint violation, got " + error.getSQLState());
    }

    @FunctionalInterface
    private interface SqlAction {
        void run() throws SQLException;
    }
}
