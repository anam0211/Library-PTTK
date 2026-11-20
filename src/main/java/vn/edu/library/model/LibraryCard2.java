package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class LibraryCard2 {
    private final int id;
    private final int readerId;
    private final String cardNumber;
    private final java.time.LocalDate issuedAt;
    private final java.time.LocalDate expiresAt;
    private final String status;

    public LibraryCard2(int id, int readerId, String cardNumber, java.time.LocalDate issuedAt, java.time.LocalDate expiresAt, String status) {
        this.id = id;
        this.readerId = readerId;
        this.cardNumber = cardNumber;
        this.issuedAt = issuedAt;
        this.expiresAt = expiresAt;
        this.status = status;
    }

    public int getId() { return id; }
    public int getReaderId() { return readerId; }
    public String getCardNumber() { return cardNumber; }
    public java.time.LocalDate getIssuedAt() { return issuedAt; }
    public java.time.LocalDate getExpiresAt() { return expiresAt; }
    public String getStatus() { return status; }
    public String getExpiryText() { return expiresAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")); }
    public boolean usableOn(java.time.LocalDate date) {
        return "Hoạt động".equals(status) && !issuedAt.isAfter(date) && !expiresAt.isBefore(date);
    }
}
