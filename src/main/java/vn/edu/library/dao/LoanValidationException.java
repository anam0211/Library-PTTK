package vn.edu.library.dao;

/** A business rejection safe to show to the librarian. */
public class LoanValidationException extends Exception {
    public LoanValidationException(String message) { super(message); }
}
