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
import model.PostDAO;
import model.User;

@MultipartConfig(
    fileSizeThreshold = 1048576, // 1MB
    maxFileSize = 10485760,      // 10MB
    maxRequestSize = 52428800    // 50MB
)
public class PostServlet extends HttpServlet {
    private PostDAO postDAO;

    @Override
    public void init() {
        postDAO = new PostDAO();
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
        if ("createPost".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            Part filePart = request.getPart("image");
            
            String imageUrl = null;
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                
                // 1. Save to the temporary build directory so it's instantly available without restart
                String buildUploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File buildUploadDir = new File(buildUploadPath);
                if (!buildUploadDir.exists()) {
                    buildUploadDir.mkdir();
                }
                String buildFilePath = buildUploadPath + File.separator + fileName;
                filePart.write(buildFilePath);
                
                // 2. Save to the permanent project directory so it survives rebuilds
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
                    System.err.println("Failed to copy image to permanent directory: " + e.getMessage());
                }

                imageUrl = "uploads/" + fileName;
            }

            boolean success = postDAO.addPost(user.getUserId(), title, content, imageUrl);
            if (success) {
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("errorMessage", "Failed to create post. Please try again.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } else if ("addComment".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String commentText = request.getParameter("commentText");
            
            postDAO.addComment(postId, user.getUserId(), commentText);
            response.sendRedirect("index.jsp");
        } else if ("deletePost".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            // In a real app we'd also check if user is admin or the post owner
            postDAO.deletePost(postId);
            response.sendRedirect("index.jsp");
        } else if ("deleteComment".equals(action)) {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            // Basic check could be added here similar to deletePost
            postDAO.deleteComment(commentId);
            response.sendRedirect("index.jsp");
        } else {
            response.sendRedirect("index.jsp");
        }
    }
    
    // Utility method to get file name from HTTP header content-disposition
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
