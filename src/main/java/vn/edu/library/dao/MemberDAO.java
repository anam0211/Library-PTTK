package vn.edu.library.dao;

import java.sql.*;
import vn.edu.library.model.Member2;
import vn.edu.library.security.Passwords;

public class MemberDAO extends DAO {
    private static final String DUMMY_HASH = Passwords.hash("Only used to equalize unsuccessful sign-ins");
    private static final String SELECT_MEMBER = """
            SELECT m.*, r.readerCode FROM tblMember m LEFT JOIN tblReader r ON r.memberId=m.id
            WHERE m.accountStatus='Active' AND (
              (m.role='Reader' AND r.memberId IS NOT NULL) OR
              (m.role='Librarian' AND EXISTS (SELECT 1 FROM tblStaff s WHERE s.memberId=m.id AND s.employmentStatus='Đang làm việc')))
            """;
    public MemberDAO() throws SQLException { super(); }
    public MemberDAO(Connection con) { super(con); }

    public Member2 authenticate(String username, String password) throws SQLException {
        Member2 member = null;
        String stored = DUMMY_HASH;
        try (PreparedStatement statement = con.prepareStatement(SELECT_MEMBER + " AND (m.username=? OR r.readerCode=?) LIMIT 1")) {
            statement.setString(1, username); statement.setString(2, username);
            try (ResultSet rows = statement.executeQuery()) {
                if (rows.next()) { member = map(rows); stored = rows.getString("authenticationInfo"); }
            }
        }
        return Passwords.verify(password, stored) ? member : null;
    }

    public Member2 getActiveById(int id) throws SQLException {
        try (PreparedStatement statement = con.prepareStatement(SELECT_MEMBER + " AND m.id=?")) {
            statement.setInt(1, id);
            try (ResultSet rows = statement.executeQuery()) { return rows.next() ? map(rows) : null; }
        }
    }

    /** Local setup only: activate untouched demo placeholders; never reset an existing real password. */
    public boolean enableDemoAccount(String username, String password) throws SQLException {
        try (PreparedStatement statement = con.prepareStatement("""
                UPDATE tblMember SET authenticationInfo=?,accountStatus='Active'
                WHERE username=? AND authenticationInfo='DEMO-NO-LOGIN' AND accountStatus='Disabled'
                """)) {
            statement.setString(1, Passwords.hash(password)); statement.setString(2, username);
            return statement.executeUpdate()==1;
        }
    }

    private static Member2 map(ResultSet rows) throws SQLException {
        return new Member2(rows.getInt("id"), rows.getString("username"), rows.getString("fullName"), rows.getString("role"), rows.getString("readerCode"));
    }
}
