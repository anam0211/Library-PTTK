package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class LoanSlip2 {
    private final int id;
    private final String slipNumber;
    private final java.time.Instant borrowedAt;
    private final Reader2 reader;
    private final LibraryCard2 libraryCard;
    private final Librarian2 librarian;
    private final java.util.List<LoanDetail2> loanDetails;

    public LoanSlip2(int id, String slipNumber, java.time.Instant borrowedAt, Reader2 reader, LibraryCard2 libraryCard, Librarian2 librarian, java.util.List<LoanDetail2> loanDetails) {
        this.id = id;
        this.slipNumber = slipNumber;
        this.borrowedAt = borrowedAt;
        this.reader = reader;
        this.libraryCard = libraryCard;
        this.librarian = librarian;
        this.loanDetails = java.util.List.copyOf(loanDetails);
    }

    public int getId() { return id; }
    public String getSlipNumber() { return slipNumber; }
    public java.time.Instant getBorrowedAt() { return borrowedAt; }
    public Reader2 getReader() { return reader; }
    public LibraryCard2 getLibraryCard() { return libraryCard; }
    public Librarian2 getLibrarian() { return librarian; }
    public java.util.List<LoanDetail2> getLoanDetails() { return loanDetails; }
    public String getBorrowedAtText() {
        return borrowedAt.atZone(java.time.ZoneId.of("Asia/Ho_Chi_Minh"))
                .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
