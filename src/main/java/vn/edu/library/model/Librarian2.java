package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class Librarian2 {
    private final int id;
    private final String code;
    private final String fullName;

    public Librarian2(int id, String code, String fullName) {
        this.id = id;
        this.code = code;
        this.fullName = fullName;
    }

    public int getId() { return id; }
    public String getCode() { return code; }
    public String getFullName() { return fullName; }
}
