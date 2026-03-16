<%-- 
    Document   : index
    Created on : 14 Mar 2026, 18:35:13
    Author     : gayan
--%>

<%@page import="model.PostDAO"%>
<%@page import="model.Post"%>
<%@page import="model.Comment"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Web Forum</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-hover: #4338CA;
            --bg-color: #F3F4F6;
            --text-color: #1F2937;
            --card-bg: #FFFFFF;
            --border: #E5E7EB;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        header {
            background-color: var(--card-bg);
            padding: 1rem 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .logo { font-size: 1.5rem; font-weight: 700; color: var(--primary); text-decoration: none; }
        .nav-links { display: flex; gap: 1.5rem; align-items: center; }
        .nav-links a { text-decoration: none; color: var(--text-color); font-weight: 500; transition: color 0.2s;}
        .nav-links a:hover { color: var(--primary); }
        .btn { background: var(--primary); color: white; border: none; padding: 0.5rem 1rem; border-radius: 6px; cursor: pointer; font-weight: 500; transition: background 0.2s; text-decoration: none;}
        .btn:hover { background: var(--primary-hover); }
        .btn-danger { background: #EF4444; }
        .btn-danger:hover { background: #DC2626; }
        
        .container { max-width: 800px; margin: 2rem auto; padding: 0 1rem; }
        
        .create-post { background: var(--card-bg); padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 2rem; transition: transform 0.2s; }
        .create-post:hover { transform: translateY(-2px); box-shadow: 0 10px 15px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 1rem; }
        .form-control { width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 6px; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        .form-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1); }
        textarea.form-control { resize: vertical; min-height: 100px; }
        
        .post-card { background: var(--card-bg); padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 1.5rem; }
        .post-header { display: flex; align-items: center; margin-bottom: 1rem; justify-content: space-between; }
        .user-info { display: flex; align-items: center; gap: 0.75rem; }
        .avatar { width: 40px; height: 40px; border-radius: 50%; background: #e0e0e0; object-fit: cover; }
        .post-meta { font-size: 0.875rem; color: #6B7280; }
        
        .post-title { font-size: 1.25rem; font-weight: 600; margin: 0 0 0.5rem 0; }
        .post-content { margin-bottom: 1rem; white-space: pre-wrap;}
        .post-image { max-width: 100%; border-radius: 8px; margin-bottom: 1rem; max-height: 400px; object-fit: contain; background: #f9fafb; display: block;}
        
        .comments-section { border-top: 1px solid var(--border); padding-top: 1rem; margin-top: 1rem; }
        .comment { background: #F9FAFB; padding: 0.75rem 1rem; border-radius: 8px; margin-bottom: 0.5rem; }
        .comment-header { display: flex; justify-content: space-between; font-size: 0.875rem; margin-bottom: 0.25rem; }
        .comment-author { font-weight: 600; }
        
        .comment-form { display: flex; gap: 0.5rem; margin-top: 1rem; }
        .comment-form input { flex: 1; }
    </style>
</head>
<body>
    <%-- Session Verification --%>
    <% 
        model.User user = (model.User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        PostDAO postDAO = new PostDAO();
        List<Post> posts = postDAO.getAllPosts();
    %>

    <header>
        <a href="index.jsp" class="logo">ForumHub</a>
        <div class="nav-links">
            <span>Welcome, <strong><%= user.getUsername() %></strong></span>
            <a href="profile.jsp">My Profile</a>
            <% if ("admin".equals(user.getRole())) { %>
                <a href="admin.jsp">Admin Dashboard</a>
            <% } %>
            <a href="logout" class="btn btn-danger">Logout</a>
        </div>
    </header>

    <div class="container">
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div style="background: #FEE2E2; color: #DC2626; padding: 1rem; border-radius: 6px; margin-bottom: 1rem;">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <div class="create-post">
            <h2 style="margin-top:0;">Create a Discussion</h2>
            <form action="PostServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="createPost">
                <div class="form-group">
                    <input type="text" name="title" class="form-control" placeholder="Thread Title" required>
                </div>
                <div class="form-group">
                    <textarea name="content" class="form-control" placeholder="What do you want to ask or share?" required></textarea>
                </div>
                <div class="form-group">
                    <label style="font-size: 0.875rem; color: #4B5563; display:block; margin-bottom:0.25rem;">Attach an image (Optional)</label>
                    <input type="file" name="image" class="form-control" accept="image/*">
                </div>
                <button type="submit" class="btn">Post Question</button>
            </form>
        </div>

        <div class="feed">
            <% if (posts != null && !posts.isEmpty()) { 
                for (Post post : posts) {
            %>
                <div class="post-card">
                    <div class="post-header">
                        <div class="user-info">
                            <img src="<%= (post.getUserProfilePic() != null && !post.getUserProfilePic().isEmpty()) ? post.getUserProfilePic() : "https://ui-avatars.com/api/?name=" + post.getUsername() + "&background=random" %>" alt="Avatar" class="avatar">
                            <div>
                                <div style="font-weight: 600;"><%= post.getUsername() %></div>
                                <div class="post-meta"><%= post.getCreatedDate() %></div>
                            </div>
                        </div>
                        <% if ("admin".equals(user.getRole()) || user.getUserId() == post.getUserId()) { %>
                            <form action="PostServlet" method="POST" style="margin:0;">
                                <input type="hidden" name="action" value="deletePost">
                                <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                                <button type="submit" class="btn btn-danger" style="padding: 0.25rem 0.5rem; font-size: 0.875rem;" onclick="return confirm('Are you sure you want to delete this post?');">Delete</button>
                            </form>
                        <% } %>
                    </div>
                    
                    <h3 class="post-title"><%= post.getTitle() %></h3>
                    <div class="post-content"><%= post.getContent() %></div>
                    
                    <% if (post.getImageUrl() != null && !post.getImageUrl().isEmpty()) { %>
                        <img src="<%= post.getImageUrl() %>" alt="Post Request Attachment" class="post-image">
                    <% } %>
                    
                    <div class="comments-section">
                        <h4 style="margin:0 0 1rem 0; font-size: 1rem;">Replies</h4>
                        <% 
                            List<Comment> comments = post.getComments();
                            if (comments != null && !comments.isEmpty()) {
                                for (Comment c : comments) {
                        %>
                            <div class="comment">
                                <div class="comment-header">
                                    <span class="comment-author"><%= c.getUsername() %></span>
                                    <span class="post-meta"><%= c.getCreatedDate() %></span>
                                </div>
                                <div><%= c.getCommentText() %></div>
                            </div>
                        <%      }
                            } else { %>
                                <div style="color: #6B7280; font-size: 0.875rem;">No replies yet. Be the first to reply!</div>
                        <%  } %>
                        
                        <form action="PostServlet" method="POST" class="comment-form">
                            <input type="hidden" name="action" value="addComment">
                            <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                            <input type="text" name="commentText" class="form-control" placeholder="Write a reply..." required>
                            <button type="submit" class="btn">Reply</button>
                        </form>
                    </div>
                </div>
            <%  }
               } else { %>
                <div style="text-align: center; padding: 3rem; color: #6B7280; background: white; border-radius: 12px;">
                    <h3>No posts yet!</h3>
                    <p>Why don't you start a new discussion above?</p>
                </div>
            <% } %>
        </div>
    </div>

   <%-- SweetAlert2 Integration for Login, Posting, and Deleting --%>
    <%
        // Get attributes
        String loginSuccess = (String) session.getAttribute("loginSuccess");
        String postSuccess = (String) session.getAttribute("postSuccess");
        String deleteSuccess = (String) session.getAttribute("deleteSuccess");
        
        String alertMessage = null;
        String alertTitle = "Success!";
        String alertIcon = "success"; // default green checkmark
        
        // Check which event just happened and clean up the session
        if (loginSuccess != null) {
            alertMessage = loginSuccess;
            alertTitle = "Welcome!";
            session.removeAttribute("loginSuccess");
        } else if (postSuccess != null) {
            alertMessage = postSuccess;
            session.removeAttribute("postSuccess");
        } else if (deleteSuccess != null) {
            alertMessage = deleteSuccess;
            alertTitle = "Deleted";
            alertIcon = "info"; // Use a blue 'info' icon for deletions
            session.removeAttribute("deleteSuccess");
        }
        
        // If any of the above happened, trigger the pop-up
        if (alertMessage != null) {
    %>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                Swal.fire({
                    title: '<%= alertTitle %>',
                    text: '<%= alertMessage %>',
                    icon: '<%= alertIcon %>',
                    confirmButtonColor: '#4F46E5', /* Your theme's primary purple */
                    timer: 3000,
                    timerProgressBar: true
                });
            });
        </script>
    <%
        }
    %>
</body>
</html>