package vn.edu.library.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import vn.edu.library.model.DocumentCopy2;

public class DocumentCopyDAO extends DAO {
    public DocumentCopyDAO() throws SQLException { super(); }
    public DocumentCopyDAO(Connection con) { super(con); }

    private static final String SELECT_COPY = """
            SELECT c.*, t.titleName, CONCAT_WS('-', s.area, s.shelf, s.compartment) AS location
            FROM tblDocumentCopy c JOIN tblDocumentTitle t ON t.id = c.documentTitleId
            LEFT JOIN tblStorageLocation s ON s.id = c.storageLocationId
            """;

    public List<DocumentCopy2> getCopiesByTitle(int titleId) throws SQLException {
        List<DocumentCopy2> copies = new ArrayList<>();
        try (PreparedStatement statement = con.prepareStatement(SELECT_COPY + " WHERE c.documentTitleId = ? ORDER BY c.copyCode")) {
            statement.setInt(1, titleId);
            try (ResultSet rows = statement.executeQuery()) { while (rows.next()) copies.add(map(rows)); }
        }
        return copies;
    }

    public DocumentCopy2 findByCode(String copyCode) throws SQLException { return find(copyCode, false); }

    DocumentCopy2 lockByCode(String copyCode) throws SQLException { return find(copyCode, true); }

    private DocumentCopy2 find(String code, boolean lock) throws SQLException {
        // The locking version locks only c, not the title/location joined by read-only searches.
        String sql = lock ? """
                SELECT c.*, (SELECT t.titleName FROM tblDocumentTitle t WHERE t.id = c.documentTitleId) AS titleName,
                  (SELECT CONCAT_WS('-', s.area, s.shelf, s.compartment) FROM tblStorageLocation s WHERE s.id = c.storageLocationId) AS location
                FROM tblDocumentCopy c WHERE c.copyCode = ? FOR UPDATE
                """ : SELECT_COPY + " WHERE c.copyCode = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, code);
            try (ResultSet rows = statement.executeQuery()) { return rows.next() ? map(rows) : null; }
        }
    }

    /** Called only by saveLoan on the same transaction connection. */
    public boolean markAsBorrowed(String[] copyCodes, String[] conditionsAtLoan) throws SQLException {
        if (con.getAutoCommit()) throw new SQLException("markAsBorrowed cần giao dịch đang mở.");
        if (copyCodes.length != conditionsAtLoan.length) throw new SQLException("Thiếu tình trạng bản tài liệu.");
        try (PreparedStatement statement = con.prepareStatement("""
                UPDATE tblDocumentCopy SET copyStatus = 'Đang được mượn', physicalCondition = ?
                WHERE copyCode = ? AND copyStatus = 'Sẵn sàng' AND usageType = 'Mượn về'
                """)) {
            for (int i = 0; i < copyCodes.length; i++) {
                statement.setString(1, conditionsAtLoan[i]); statement.setString(2, copyCodes[i]);
                if (statement.executeUpdate() != 1) return false;
            }
        }
        return true;
    }

    static DocumentCopy2 map(ResultSet rows) throws SQLException {
        String location = rows.getString("location");
        return new DocumentCopy2(rows.getInt("id"), rows.getString("copyCode"), rows.getInt("documentTitleId"),
                rows.getString("titleName"), location == null || location.isBlank() ? "Chưa có thông tin" : location,
                rows.getString("physicalCondition"), rows.getString("copyStatus"), rows.getString("usageType"), rows.getString("note"));
    }
}
