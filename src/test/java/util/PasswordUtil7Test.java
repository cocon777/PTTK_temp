package util;

import org.junit.Test;
import static org.junit.Assert.*;

public class PasswordUtil7Test {
    @Test public void storesSaltedHashesAndRejectsWrongPassword() {
        String first = PasswordUtil7.hash("CineMan@Test123");
        String second = PasswordUtil7.hash("CineMan@Test123");
        assertNotEquals(first, second);
        assertTrue(PasswordUtil7.verify("CineMan@Test123", first));
        assertFalse(PasswordUtil7.verify("wrong", first));
        assertFalse(PasswordUtil7.verify("CineMan@Test123", "not-a-hash"));
        assertFalse(PasswordUtil7.verify(null, first));
    }

    @Test public void rejectsBcryptTruncationIncludingUnicodeBytes() {
        assertTrue(PasswordUtil7.isValid("a".repeat(72)));
        assertFalse(PasswordUtil7.isValid("a".repeat(73)));
        assertFalse(PasswordUtil7.isValid("ắ".repeat(25)));
        assertFalse(PasswordUtil7.isValid("short"));
        assertFalse(PasswordUtil7.isValid(null));
        String hash = PasswordUtil7.hash("a".repeat(72));
        assertFalse(PasswordUtil7.verify("a".repeat(73), hash));
    }
}
