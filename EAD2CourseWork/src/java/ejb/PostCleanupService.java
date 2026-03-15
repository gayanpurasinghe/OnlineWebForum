package ejb;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DBconn;

@Singleton
public class PostCleanupService {

    private static final Logger LOGGER = Logger.getLogger(PostCleanupService.class.getName());

    // Schedule to run every 3 months.
    // E.g. runs January 1st, April 1st, July 1st, October 1st at midnight.
    @Schedule(second = "0", minute = "0", hour = "0", dayOfMonth = "1", month = "Jan,Apr,Jul,Oct", year = "*", persistent = false)
    public void cleanupOldPosts() {
        LOGGER.log(Level.INFO, "Starting EJB Scheduled Task: Post Cleanup...");
        DBconn cn = new DBconn();
        if (cn.con == null) {
            LOGGER.log(Level.SEVERE, "Database connection failed during post cleanup.");
            return;
        }

        // Delete posts older than 3 months
        String sql = "DELETE FROM posts WHERE created_date < DATE_SUB(NOW(), INTERVAL 3 MONTH)";
        try (PreparedStatement stmt = cn.con.prepareStatement(sql)) {
            int rowsDeleted = stmt.executeUpdate();
            LOGGER.log(Level.INFO, "EJB Scheduled Task completed. Deleted {0} old posts.", rowsDeleted);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error executing post cleanup query: {0}", ex.getMessage());
        } finally {
            try {
                if (cn.con != null && !cn.con.isClosed()) {
                    cn.con.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to close connection after cleanup.", e);
            }
        }
    }
}
