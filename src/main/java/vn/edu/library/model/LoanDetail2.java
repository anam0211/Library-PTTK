package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class LoanDetail2 {
    private final int id;
    private final DocumentCopy2 documentCopy;
    private final java.time.LocalDate dueDate;
    private final String conditionAtLoan;
    private final String note;

    public LoanDetail2(int id, DocumentCopy2 documentCopy, java.time.LocalDate dueDate, String conditionAtLoan, String note) {
        this.id = id;
        this.documentCopy = documentCopy;
        this.dueDate = dueDate;
        this.conditionAtLoan = conditionAtLoan;
        this.note = note;
    }

    public int getId() { return id; }
    public DocumentCopy2 getDocumentCopy() { return documentCopy; }
    public java.time.LocalDate getDueDate() { return dueDate; }
    public String getConditionAtLoan() { return conditionAtLoan; }
    public String getNote() { return note; }
    public String getDueDateText() { return dueDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")); }
}
