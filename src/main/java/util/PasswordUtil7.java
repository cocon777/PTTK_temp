package util;

import java.nio.charset.StandardCharsets;
import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtil7 {
    private PasswordUtil7() { }

    public static boolean isValid(String password) {
        return password != null && password.length() >= 8
                && password.getBytes(StandardCharsets.UTF_8).length <= 72;
    }

    public static String hash(String password) {
        if (!isValid(password)) {
            throw new IllegalArgumentException("Mật khẩu cần ít nhất 8 ký tự và tối đa 72 byte UTF-8.");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public static boolean verify(String password, String hash) {
        if (password == null || hash == null
                || password.getBytes(StandardCharsets.UTF_8).length > 72) return false;
        try {
            return BCrypt.checkpw(password, hash);
        } catch (IllegalArgumentException ex) {
            return false;
        }
    }
}
