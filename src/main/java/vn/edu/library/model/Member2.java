package vn.edu.library.model;

/** Signed-in identity only. Passwords/hashes never enter the HTTP session. */
public final class Member2 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private final int id;
    private final String username;
    private final String fullName;
    private final String role;
    private final String readerCode;

    public Member2(int id, String username, String fullName, String role, String readerCode) {
        this.id = id; this.username = username; this.fullName = fullName;
        this.role = role; this.readerCode = readerCode;
    }

    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getFullName() { return fullName; }
    public String getRole() { return role; }
    public String getReaderCode() { return readerCode; }
    public boolean isLibrarian() { return "Librarian".equals(role); }
    public String getHomePath() { return isLibrarian() ? "/nhan-vien" : "/ban-doc"; }
    public String getDisplayCode() { return readerCode == null ? username : readerCode; }
}
