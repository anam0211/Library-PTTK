package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class BorrowingPolicy2 {
    private final int id;
    private final int maximumCopies;
    private final int loanPeriodDays;
    private final String dueDateRule;
    private final String borrowingRestriction;

    public BorrowingPolicy2(int id, int maximumCopies, int loanPeriodDays, String dueDateRule, String borrowingRestriction) {
        this.id = id;
        this.maximumCopies = maximumCopies;
        this.loanPeriodDays = loanPeriodDays;
        this.dueDateRule = dueDateRule;
        this.borrowingRestriction = borrowingRestriction;
    }

    public int getId() { return id; }
    public int getMaximumCopies() { return maximumCopies; }
    public int getLoanPeriodDays() { return loanPeriodDays; }
    public String getDueDateRule() { return dueDateRule; }
    public String getBorrowingRestriction() { return borrowingRestriction; }
    public java.time.LocalDate dueDate(java.time.LocalDate borrowDate) { return borrowDate.plusDays(loanPeriodDays); }
}
