package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminDAO {
    private DBconn db;

    public AdminDAO() {
        db = new DBconn();
    }

    public int getTotalUsers() {
        String query = "SELECT COUNT(*) FROM users WHERE role = 'user'";
        try (PreparedStatement pstmt = db.con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int getTotalActivePosts() {
        String query = "SELECT COUNT(*) FROM posts";
        try (PreparedStatement pstmt = db.con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT user_id, username, email, role, profile_pic_url, is_banned FROM users WHERE role = 'user' ORDER BY user_id DESC";
        try (PreparedStatement pstmt = db.con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setProfilePicUrl(rs.getString("profile_pic_url"));
                user.setBanned(rs.getBoolean("is_banned"));
                users.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return users;
    }

    public boolean banUser(int userId, boolean banStatus) {
        String query = "UPDATE users SET is_banned = ? WHERE user_id = ?";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setBoolean(1, banStatus);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AdminDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AdminDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
}
