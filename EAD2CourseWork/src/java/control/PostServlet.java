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
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                filePart.write(uploadPath + File.separator + fileName);
                imageUrl = "uploads/" + fileName;
            }

            boolean success = postDAO.addPost(user.getUserId(), title, content, imageUrl);
            if (success) {
                // NEW: Trigger the success pop-up for creating a post
                session.setAttribute("postSuccess", "Your discussion has been posted successfully!");
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
            
            // NEW: Trigger the info pop-up for deleting a post
            session.setAttribute("deleteSuccess", "The post was successfully deleted.");
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