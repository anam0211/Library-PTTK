package vn.edu.library.db;

import java.io.IOException;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Read-only check against a real MySQL database; not invoked by the demo UI or mvn verify. */
public final class JdbcSmokeCheck {
    private JdbcSmokeCheck() { }

    public static void main(String[] args) {
        System.setOut(new PrintStream(System.out, true, StandardCharsets.UTF_8));
        try (Connection connection = ConnectionFactory.fromEnvironment().openConnection()) {
            connection.setReadOnly(true);
            // A failed assertion prints neither driver messages nor configuration credentials.
            verify(connection);
            System.out.println("JDBC CHECK PASSED (real MySQL queries; no data modified).");
        } catch (SQLException exception) {
            throw new IllegalStateException("JDBC CHECK FAILED; SQLState=" + exception.getSQLState()
                    + ", vendorCode=" + exception.getErrorCode()
                    + ". Check MySQL service, credentials, database and SQL scripts.");
        } catch (IOException | IllegalArgumentException exception) {
            throw new IllegalStateException("JDBC CHECK FAILED: external database configuration is missing or invalid. "
                    + "See README.md.");
        } finally {
            // This command owns its JVM lifecycle; future application DAOs must not shut down the driver.
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
        }
    }

    static void verify(Connection connection) throws SQLException {
        String readerSql = """
                SELECT r.readerCode, m.fullName, c.cardNumber, c.expiresAt
                FROM tblReader r JOIN tblMember m ON m.id = r.memberId
                JOIN tblCardApplication a ON a.readerId = r.memberId
                JOIN tblLibraryCard c ON c.cardApplicationId = a.id
                WHERE r.readerCode = ? AND c.cardNumber = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(readerSql)) {
            statement.setString(1, "BD0017");
            statement.setString(2, "TD017");
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next() || !"Nguyễn Văn An".equals(rows.getString("fullName"))) {
                    throw new SQLException("Expected demo reader/card is missing or mismatched.", "02000");
                }
                System.out.printf("READER | %s | %s | %s | %s%n", rows.getString("readerCode"),
                        rows.getString("fullName"), rows.getString("cardNumber"), rows.getDate("expiresAt"));
            }
        }
        String copySql = """
                SELECT c.copyCode, t.titleName, c.copyStatus
                FROM tblDocumentCopy c JOIN tblDocumentTitle t ON t.id = c.documentTitleId
                WHERE c.copyCode = ?
                """;
        String[][] copies = {{"BT001", "Cơ sở dữ liệu"}, {"BT002", "Lập trình hướng đối tượng"}};
        try (PreparedStatement statement = connection.prepareStatement(copySql)) {
            for (String[] copy : copies) {
                statement.setString(1, copy[0]);
                try (ResultSet rows = statement.executeQuery()) {
                    if (!rows.next() || !copy[1].equals(rows.getString("titleName"))) {
                        throw new SQLException("Expected copy/title link is missing or mismatched.", "02000");
                    }
                    System.out.printf("COPY | %s | %s | %s%n", rows.getString("copyCode"),
                            rows.getString("titleName"), rows.getString("copyStatus"));
                }
            }
        }
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT titleName FROM tblDocumentTitle WHERE titleName LIKE ? ORDER BY titleName")) {
            statement.setString(1, "%cơ sở dữ liệu%");
            try (ResultSet rows = statement.executeQuery()) {
                int count = 0;
                while (rows.next()) {
                    System.out.println("SEARCH | " + rows.getString("titleName"));
                    count++;
                }
                if (count < 2) {
                    throw new SQLException("Expected demo search results are missing.", "02000");
                }
            }
        }
    }
}
