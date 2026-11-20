package vn.edu.library.dao;

import org.junit.jupiter.api.Test;
import vn.edu.library.model.Member2;
import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

class MemberDAOTest {
    @Test void existingReaderAndStaffSignInWithTheirDatabaseRole() throws Exception {
        String password = System.getenv("LIBMAN_TEST_PASSWORD");
        assumeTrue("true".equalsIgnoreCase(System.getenv("LIBMAN_DB_INTEGRATION")) && password != null);
        try (MemberDAO dao = new MemberDAO()) {
            Member2 staff = dao.authenticate(System.getenv().getOrDefault("LIBMAN_TEST_USERNAME","NV001"),password);
            assertNotNull(staff); assertTrue(staff.isLibrarian());
            String readerPassword = System.getenv().getOrDefault("LIBMAN_TEST_READER_PASSWORD",password);
            Member2 reader = dao.authenticate("BD0101",readerPassword);
            assertNotNull(reader); assertEquals("Reader",reader.getRole());
            assertEquals(reader.getId(),dao.authenticate("demo.more.BD0101",readerPassword).getId());
            assertEquals(reader.getId(),dao.getActiveById(reader.getId()).getId());
        }
    }

    @Test void wrongCredentialsAndDisabledAccountsAreRejected() throws Exception {
        assumeTrue("true".equalsIgnoreCase(System.getenv("LIBMAN_DB_INTEGRATION")));
        try (MemberDAO dao = new MemberDAO()) {
            assertNull(dao.authenticate("NV001","incorrect-password"));
            assertNull(dao.authenticate("demo.reader.BD004","incorrect-password"));
            assertNull(dao.authenticate("' OR 1=1 --","incorrect-password"));
            assertNull(dao.getActiveById(-1));
        }
    }
}
