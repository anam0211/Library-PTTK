package vn.edu.library.model;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** One unfinished lending operation in an HTTP session. Never writes to MySQL. */
public class LoanDraft {
    private final int readerId;
    private final String token = java.util.UUID.randomUUID().toString();
    private final Map<String, DocumentCopy2> copies = new LinkedHashMap<>();
    public LoanDraft(int readerId) { this.readerId = readerId; }
    public int getReaderId() { return readerId; }
    public String getToken() { return token; }
    public List<DocumentCopy2> getCopies() { return List.copyOf(copies.values()); }
    public boolean contains(String code) { return copies.containsKey(code); }
    public void add(DocumentCopy2 copy) { copies.put(copy.getCopyCode(), copy); }
    public void remove(String code) { copies.remove(code); }
    public int getSize() { return copies.size(); }
}
