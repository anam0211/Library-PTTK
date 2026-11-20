package vn.edu.library.db;

import java.util.Map;
import java.util.Properties;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class DatabaseConfigTest {
    private Properties file() {
        Properties properties = new Properties();
        properties.setProperty("db.user", "example_user");
        properties.setProperty("db.password", "test-only-value");
        return properties;
    }

    @Test
    void environmentOverridesFileAndKeepsCredentialsOutOfUrlAndToString() {
        DatabaseConfig config = DatabaseConfig.from(file(), Map.of(
                "LIBMAN_DB_HOST", "mysql.example.test", "LIBMAN_DB_PORT", "3307",
                "LIBMAN_DB_NAME", "example_db", "LIBMAN_DB_USER", "external_user",
                "LIBMAN_DB_PASSWORD", "external-secret-test-only"));
        assertEquals("jdbc:mysql://mysql.example.test:3307/example_db", config.jdbcUrl());
        assertEquals("external_user", config.connectionProperties().getProperty("user"));
        assertEquals("external-secret-test-only", config.connectionProperties().getProperty("password"));
        assertFalse(config.toString().contains("external-secret-test-only"));
        assertFalse(config.jdbcUrl().contains("external-secret-test-only"));
        Properties copy = config.connectionProperties();
        copy.setProperty("password", "changed");
        assertEquals("external-secret-test-only", config.connectionProperties().getProperty("password"));
    }

    @Test
    void missingCredentialsFailBeforeConnectingButExplicitEmptyPasswordIsAccepted() {
        assertThrows(IllegalArgumentException.class, () -> DatabaseConfig.from(new Properties(), Map.of()));
        assertEquals("", DatabaseConfig.from(file(), Map.of("LIBMAN_DB_PASSWORD", ""))
                .connectionProperties().getProperty("password"));
    }

    @Test
    void rejectsMalformedPortAndUrlInjectionWithoutEchoingInput() {
        for (String port : new String[] {"0", "65536", "bad-port"}) {
            assertThrows(IllegalArgumentException.class,
                    () -> DatabaseConfig.from(file(), Map.of("LIBMAN_DB_PORT", port)));
        }
        IllegalArgumentException error = assertThrows(IllegalArgumentException.class,
                () -> DatabaseConfig.from(file(), Map.of("LIBMAN_DB_NAME", "db?password=secret")));
        assertFalse(error.getMessage().contains("secret"));
    }

    @Test
    void setsUnicodeTimeoutsAndExplicitTimezoneAndValidatesSecurityOptions() {
        Properties properties = DatabaseConfig.from(file(), Map.of()).connectionProperties();
        assertEquals("UTF-8", properties.getProperty("characterEncoding"));
        assertEquals("UTC", properties.getProperty("connectionTimeZone"));
        assertEquals("5000", properties.getProperty("connectTimeout"));
        assertEquals("false", properties.getProperty("allowPublicKeyRetrieval"));
        assertThrows(IllegalArgumentException.class,
                () -> DatabaseConfig.from(file(), Map.of("LIBMAN_DB_SSL_MODE", "arbitrary")));
        assertThrows(IllegalArgumentException.class,
                () -> DatabaseConfig.from(file(), Map.of("LIBMAN_DB_ALLOW_PUBLIC_KEY_RETRIEVAL", "maybe")));
    }
}
