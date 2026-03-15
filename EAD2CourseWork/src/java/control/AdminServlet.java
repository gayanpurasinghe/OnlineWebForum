package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.AdminDAO;
import model.User;

public class AdminServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("admin.jsp");
            return;
        }

        try {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            boolean success = false;
            
            if ("ban".equals(action)) {
                success = adminDAO.banUser(targetUserId, true);
            } else if ("unban".equals(action)) {
                success = adminDAO.banUser(targetUserId, false);
            } else if ("delete".equals(action)) {
                success = adminDAO.deleteUser(targetUserId);
            }

            if (success) {
                response.sendRedirect("admin.jsp?success=1");
            } else {
                response.sendRedirect("admin.jsp?error=1");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("admin.jsp?error=1");
        }
    }
}
