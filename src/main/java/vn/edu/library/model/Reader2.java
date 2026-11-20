package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class Reader2 {
    private final int id;
    private final String readerCode;
    private final String fullName;
    private final String readerStatus;

    public Reader2(int id, String readerCode, String fullName, String readerStatus) {
        this.id = id;
        this.readerCode = readerCode;
        this.fullName = fullName;
        this.readerStatus = readerStatus;
    }

    public int getId() { return id; }
    public String getReaderCode() { return readerCode; }
    public String getFullName() { return fullName; }
    public String getReaderStatus() { return readerStatus; }
    private LibraryCard2 card;
    public LibraryCard2 getCard() { return card; }
    public void setCard(LibraryCard2 card) { this.card = card; }
}
