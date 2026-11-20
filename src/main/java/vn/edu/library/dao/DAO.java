package vn.edu.library.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import vn.edu.library.db.ConnectionFactory;

/** A DAO owns a fresh connection, or borrows the transaction's existing connection. */
public class DAO implements AutoCloseable {
    protected final Connection con;
    private final boolean ownsConnection;

    public DAO() throws SQLException {
        try {
            con = ConnectionFactory.fromEnvironment().openConnection();
        } catch (IOException | IllegalArgumentException exception) {
            throw new SQLException("Chưa cấu hình kết nối MySQL. Xem README.md.", "08001");
        }
        ownsConnection = true;
    }

    public DAO(Connection con) {
        this.con = con;
        ownsConnection = false;
    }

    public Connection connection() { return con; }

    @Override public void close() throws SQLException {
        if (ownsConnection) con.close();
    }

    protected static String keyword(String value) {
        String text = value == null ? "" : value.trim().replaceAll("\\s+", " ");
        return "%" + text.replace("!", "!!").replace("%", "!%").replace("_", "!_") + "%";
    }
}
