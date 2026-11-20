package vn.edu.library.model;

/** Data for the two modules, named after the report design. */
public class DocumentTitle2 {
    private final int id;
    private final String titleName;
    private final String authors;
    private final String typeName;
    private final String publisherName;
    private final Integer publicationYear;
    private final String edition;
    private final String language;
    private final Integer pageCount;
    private final String isbn;
    private final String description;
    private final String coverImage;
    private final int availableCopyCount;

    public DocumentTitle2(int id, String titleName, String authors, String typeName, String publisherName, Integer publicationYear, String edition, String language, Integer pageCount, String isbn, String description, String coverImage, int availableCopyCount) {
        this.id = id;
        this.titleName = titleName;
        this.authors = authors;
        this.typeName = typeName;
        this.publisherName = publisherName;
        this.publicationYear = publicationYear;
        this.edition = edition;
        this.language = language;
        this.pageCount = pageCount;
        this.isbn = isbn;
        this.description = description;
        this.coverImage = coverImage;
        this.availableCopyCount = availableCopyCount;
    }

    public int getId() { return id; }
    public String getTitleName() { return titleName; }
    public String getAuthors() { return authors; }
    public String getTypeName() { return typeName; }
    public String getPublisherName() { return publisherName; }
    public Integer getPublicationYear() { return publicationYear; }
    public String getEdition() { return edition; }
    public String getLanguage() { return language; }
    public Integer getPageCount() { return pageCount; }
    public String getIsbn() { return isbn; }
    public String getDescription() { return description; }
    public String getCoverImage() { return coverImage; }
    public int getAvailableCopyCount() { return availableCopyCount; }
    public String getCode() { return String.format("DT%03d", id); }
}
