package vn.edu.library.db;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** JDBC foundation for future DAOs. Callers close their own connections with try-with-resources. */
public final class ConnectionFactory {
    private final DatabaseConfig config;

    public ConnectionFactory(DatabaseConfig config) {
        this.config = java.util.Objects.requireNonNull(config);
    }

    public static ConnectionFactory fromEnvironment() throws IOException {
        return new ConnectionFactory(DatabaseConfig.load());
    }

    public Connection openConnection() throws SQLException {
        try {
            // Also works with Maven exec's classloader and a deployed WAR.
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException exception) {
            throw new SQLException("MySQL Connector/J is missing from the runtime classpath.", "08001");
        }
        return DriverManager.getConnection(config.jdbcUrl(), config.connectionProperties());
    }
}
