package vn.edu.library.security;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PasswordsTest {
    @Test void samePasswordHasDifferentSaltAndStillVerifies() {
        String first = Passwords.hash("Mật khẩu thử 123!"), second = Passwords.hash("Mật khẩu thử 123!");
        assertNotEquals(first, second);
        assertTrue(Passwords.verify("Mật khẩu thử 123!", first));
        assertTrue(Passwords.verify("Mật khẩu thử 123!", second));
        assertFalse(Passwords.verify("Mật khẩu khác", first));
        assertTrue(first.length()<255);
    }

    @Test void malformedOrExcessiveWorkFactorCannotBeAccepted() {
        for (String stored : new String[] {"DEMO-NO-LOGIN", "plain-password", "pbkdf2_sha256$2000000000$x$x", "pbkdf2_sha256$600000$?$?"})
            assertFalse(Passwords.verify("some password", stored));
        assertFalse(Passwords.verify(null, null));
    }
}
