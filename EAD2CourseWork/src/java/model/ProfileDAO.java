package model;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProfileDAO {
    private DBconn db;

    public ProfileDAO() {
        db = new DBconn();
    }

    public boolean updateProfilePic(int userId, String imageUrl) {
        String query = "UPDATE users SET profile_pic_url = ? WHERE user_id = ?";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setString(1, imageUrl);
            pstmt.setInt(2, userId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProfileDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
}
