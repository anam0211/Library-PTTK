package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class DocumentCopy2 {
    private final int id;
    private final String copyCode;
    private final int documentTitleId;
    private final String titleName;
    private final String location;
    private final String physicalCondition;
    private final String copyStatus;
    private final String usageType;
    private final String note;

    public DocumentCopy2(int id, String copyCode, int documentTitleId, String titleName, String location, String physicalCondition, String copyStatus, String usageType, String note) {
        this.id = id;
        this.copyCode = copyCode;
        this.documentTitleId = documentTitleId;
        this.titleName = titleName;
        this.location = location;
        this.physicalCondition = physicalCondition;
        this.copyStatus = copyStatus;
        this.usageType = usageType;
        this.note = note;
    }

    public int getId() { return id; }
    public String getCopyCode() { return copyCode; }
    public int getDocumentTitleId() { return documentTitleId; }
    public String getTitleName() { return titleName; }
    public String getLocation() { return location; }
    public String getPhysicalCondition() { return physicalCondition; }
    public String getCopyStatus() { return copyStatus; }
    public String getUsageType() { return usageType; }
    public String getNote() { return note; }
    public String getTitleCode() { return String.format("DT%03d", documentTitleId); }
    public boolean isAvailable() { return "Sẵn sàng".equals(copyStatus) && "Mượn về".equals(usageType); }
    public DocumentCopy2 withInspection(String condition, String conditionNote) {
        return new DocumentCopy2(id, copyCode, documentTitleId, titleName, location,
                condition, copyStatus, usageType, conditionNote);
    }
}
