package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class loginCheck {
    private String lastError = "";

    public User validate(String username, String password) {
        DBconn cn = new DBconn();
        if (cn.con == null) {
            lastError = "Database connection failed: " + cn.lastError;
            return null;
        }

        String sql = "SELECT * FROM users WHERE username = ? AND password = SHA2(?, 256)";
        try (PreparedStatement stmt = cn.con.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                boolean isBanned = rs.getBoolean("is_banned");
                if (isBanned) {
                    lastError = "Your account has been banned by an administrator. please contact via forumhub@email.com";
                    return null;
                }
                
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setProfilePicUrl(rs.getString("profile_pic_url"));
                user.setBanned(false);
                return user;
            } else {
                lastError = "Invalid username or password.";
                return null;
            }
        } catch (SQLException ex) {
            lastError = "Database error: " + ex.getMessage();
            return null;
        }
    }

    public String getLastError() {
        return lastError;
    }
}
