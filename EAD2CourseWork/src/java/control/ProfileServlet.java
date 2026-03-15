package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;
import model.ProfileDAO;
import model.User;

@MultipartConfig(
    fileSizeThreshold = 1048576, // 1MB
    maxFileSize = 10485760,      // 10MB
    maxRequestSize = 52428800    // 50MB
)
public class ProfileServlet extends HttpServlet {
    private ProfileDAO profileDAO;

    @Override
    public void init() {
        profileDAO = new ProfileDAO();
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
        String action = request.getParameter("action");
        
        if ("uploadPic".equals(action)) {
            Part filePart = request.getPart("profilePic");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                filePart.write(uploadPath + File.separator + fileName);
                String imageUrl = "uploads/" + fileName;
                
                boolean success = profileDAO.updateProfilePic(user.getUserId(), imageUrl);
                if (success) {
                    user.setProfilePicUrl(imageUrl);
                    session.setAttribute("user", user);
                    response.sendRedirect("profile.jsp?success=1");
                } else {
                    response.sendRedirect("profile.jsp?error=1");
                }
            } else {
                 response.sendRedirect("profile.jsp");
            }
        } else {
            response.sendRedirect("profile.jsp");
        }
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
