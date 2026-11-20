package vn.edu.library.db;

import java.io.IOException;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

/** External configuration only; never contains a source-code password or logs credentials. */
public final class DatabaseConfig {
    private final String host;
    private final int port;
    private final String database;
    private final Properties connectionProperties;

    private DatabaseConfig(String host, int port, String database, Properties properties) {
        this.host = host;
        this.port = port;
        this.database = database;
        this.connectionProperties = properties;
    }

    public static DatabaseConfig load() throws IOException {
        Map<String, String> environment = System.getenv();
        String file = System.getProperty("libman.db.config", environment.get("LIBMAN_DB_CONFIG"));
        Properties properties = new Properties();
        Path path = file == null ? Path.of("config", "database.properties") : Path.of(file);
        if (file != null || Files.exists(path)) {
            try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
                properties.load(reader);
            }
        }
        return from(properties, environment);
    }

    static DatabaseConfig from(Properties file, Map<String, String> environment) {
        String host = value(file, environment, "host", "127.0.0.1");
        String database = value(file, environment, "name", "libman");
        if (!host.matches("[A-Za-z0-9._-]+") || !database.matches("[A-Za-z0-9_]+")) {
            throw new IllegalArgumentException("Invalid MySQL host or database name.");
        }
        int port;
        try {
            port = Integer.parseInt(value(file, environment, "port", "3306"));
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("MySQL port must be an integer.");
        }
        if (port < 1 || port > 65535) {
            throw new IllegalArgumentException("MySQL port must be between 1 and 65535.");
        }
        String user = value(file, environment, "user", null);
        String password = value(file, environment, "password", null);
        if (user == null || user.isBlank() || password == null) {
            throw new IllegalArgumentException("Configure LIBMAN_DB_USER and LIBMAN_DB_PASSWORD, "
                    + "or db.user and db.password in an external properties file.");
        }
        String sslMode = value(file, environment, "ssl_mode", "PREFERRED");
        if (!Set.of("DISABLED", "PREFERRED", "REQUIRED", "VERIFY_CA", "VERIFY_IDENTITY").contains(sslMode)) {
            throw new IllegalArgumentException("Invalid MySQL SSL mode.");
        }
        String retrieveKey = value(file, environment, "allow_public_key_retrieval", "false");
        if (!Set.of("true", "false").contains(retrieveKey)) {
            throw new IllegalArgumentException("Public key retrieval must be true or false.");
        }
        Properties connection = new Properties();
        connection.setProperty("user", user);
        connection.setProperty("password", password);
        connection.setProperty("characterEncoding", "UTF-8");
        connection.setProperty("connectionCollation", "utf8mb4_0900_ai_ci");
        connection.setProperty("connectionTimeZone", "UTC");
        connection.setProperty("forceConnectionTimeZoneToSession", "true");
        connection.setProperty("connectTimeout", "5000");
        connection.setProperty("socketTimeout", "10000");
        connection.setProperty("sslMode", sslMode);
        connection.setProperty("allowPublicKeyRetrieval", retrieveKey);
        return new DatabaseConfig(host, port, database, connection);
    }

    private static String value(Properties file, Map<String, String> environment, String key, String fallback) {
        String variable = "LIBMAN_DB_" + key.toUpperCase(java.util.Locale.ROOT);
        return environment.containsKey(variable) ? environment.get(variable) : file.getProperty("db." + key, fallback);
    }

    String jdbcUrl() {
        return "jdbc:mysql://" + host + ":" + port + "/" + database;
    }

    Properties connectionProperties() {
        return (Properties) connectionProperties.clone();
    }

    @Override
    public String toString() {
        return "DatabaseConfig[credentials redacted]";
    }
}
