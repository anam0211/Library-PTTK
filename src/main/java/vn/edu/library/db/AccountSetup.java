package vn.edu.library.db;

import vn.edu.library.dao.MemberDAO;

/** Activate a seed account with an externally supplied application password (not the MySQL password). */
public final class AccountSetup {
    public static void main(String[] args) throws Exception {
        String username = System.getenv("LIBMAN_ACCOUNT_USERNAME");
        String password = System.getenv("LIBMAN_ACCOUNT_PASSWORD");
        if (username == null || password == null || password.length()<8 || password.length()>128)
            throw new IllegalArgumentException("Set LIBMAN_ACCOUNT_USERNAME and LIBMAN_ACCOUNT_PASSWORD (8–128 characters).");
        try (MemberDAO dao = new MemberDAO()) {
            boolean enabled = dao.enableDemoAccount(username, password);
            System.out.println(enabled ? "Demo account activated: " + username : "Account unchanged (not an untouched demo placeholder).");
        } finally { com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown(); }
    }
}
