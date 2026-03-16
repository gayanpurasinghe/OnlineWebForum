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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import model.ConfigReader;
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
                // 1. Save to the temporary build directory
                String buildUploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File buildUploadDir = new File(buildUploadPath);
                if (!buildUploadDir.exists()) {
                    buildUploadDir.mkdir();
                }
                String buildFilePath = buildUploadPath + File.separator + fileName;
                filePart.write(buildFilePath);
                
                // 2. Save to the permanent project directory
                String projectBasePath = ConfigReader.getProperty("PROJECT_BASE_PATH");
                String permanentUploadPath = projectBasePath + File.separator + "web" + File.separator + "uploads";
                File permanentUploadDir = new File(permanentUploadPath);
                if (!permanentUploadDir.exists()) {
                    permanentUploadDir.mkdir();
                }
                String permanentFilePath = permanentUploadPath + File.separator + fileName;
                
                try {
                    Files.copy(Paths.get(buildFilePath), Paths.get(permanentFilePath), StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e) {
                    System.err.println("Failed to copy profile picture to permanent directory: " + e.getMessage());
                }

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
