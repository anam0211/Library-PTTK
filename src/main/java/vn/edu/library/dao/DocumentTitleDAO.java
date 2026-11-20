package vn.edu.library.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import vn.edu.library.model.DocumentTitle2;

public class DocumentTitleDAO extends DAO {
    public DocumentTitleDAO() throws SQLException { super(); }
    public DocumentTitleDAO(Connection con) { super(con); }

    private static final String SELECT_TITLE = """
            SELECT t.*, ty.typeName, p.publisherName,
              (SELECT GROUP_CONCAT(a.authorName ORDER BY au.authorOrder, a.id SEPARATOR ', ')
               FROM tblAuthorship au JOIN tblAuthor a ON a.id = au.authorId
               WHERE au.documentTitleId = t.id) AS authors
            FROM tblDocumentTitle t JOIN tblDocumentType ty ON ty.id = t.documentTypeId
            LEFT JOIN tblPublisher p ON p.id = t.publisherId
            """;

    public List<DocumentTitle2> searchByName(String keyword) throws SQLException {
        List<DocumentTitle2> titles = new ArrayList<>();
        if (keyword == null || keyword.isBlank()) return titles;
        try (PreparedStatement statement = con.prepareStatement(SELECT_TITLE
                + " WHERE t.titleName LIKE ? ESCAPE '!' ORDER BY t.titleName, t.id")) {
            statement.setString(1, keyword(keyword));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) titles.add(map(rows, 0));
            }
        }
        // SQ1_4: one count call per title; never count author-join rows as copies.
        List<DocumentTitle2> result = new ArrayList<>();
        for (DocumentTitle2 title : titles) result.add(withCount(title, getAvailableCopyCount(title.getId())));
        return result;
    }

    public int getAvailableCopyCount(int titleId) throws SQLException {
        try (PreparedStatement statement = con.prepareStatement("""
                SELECT COUNT(*) FROM tblDocumentCopy
                WHERE documentTitleId = ? AND copyStatus = 'Sẵn sàng' AND usageType = 'Mượn về'
                """)) {
            statement.setInt(1, titleId);
            try (ResultSet rows = statement.executeQuery()) { rows.next(); return rows.getInt(1); }
        }
    }

    public DocumentTitle2 getDetails(int titleId) throws SQLException {
        DocumentTitle2 title;
        try (PreparedStatement statement = con.prepareStatement(SELECT_TITLE + " WHERE t.id = ?")) {
            statement.setInt(1, titleId);
            try (ResultSet rows = statement.executeQuery()) { title = rows.next() ? map(rows, 0) : null; }
        }
        return title == null ? null : withCount(title, getAvailableCopyCount(titleId));
    }

    private DocumentTitle2 map(ResultSet rows, int count) throws SQLException {
        return new DocumentTitle2(rows.getInt("id"), rows.getString("titleName"), rows.getString("authors"),
                rows.getString("typeName"), rows.getString("publisherName"), (Integer) rows.getObject("publicationYear"),
                rows.getString("edition"), rows.getString("language"), (Integer) rows.getObject("pageCount"),
                rows.getString("isbn"), rows.getString("description"), rows.getString("coverImage"), count);
    }

    private DocumentTitle2 withCount(DocumentTitle2 t, int count) {
        return new DocumentTitle2(t.getId(), t.getTitleName(), t.getAuthors(), t.getTypeName(), t.getPublisherName(),
                t.getPublicationYear(), t.getEdition(), t.getLanguage(), t.getPageCount(), t.getIsbn(),
                t.getDescription(), t.getCoverImage(), count);
    }
}
