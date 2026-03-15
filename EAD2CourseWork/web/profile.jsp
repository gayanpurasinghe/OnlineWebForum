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
    <title>My Profile - Online Web Forum</title>
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
        
        .profile-header { background: var(--card-bg); padding: 2rem; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 2rem; text-align: center; }
        .profile-avatar { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 4px solid var(--border); margin-bottom: 1rem;}
        
        .form-group { margin-bottom: 1rem; }
        .form-control { width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 6px; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        
        .post-card { background: var(--card-bg); padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 1.5rem; }
        .post-header { display: flex; align-items: center; margin-bottom: 1rem; justify-content: space-between; }
        .post-meta { font-size: 0.875rem; color: #6B7280; }
        .post-title { font-size: 1.25rem; font-weight: 600; margin: 0 0 0.5rem 0; }
        .post-content { margin-bottom: 1rem; white-space: pre-wrap;}
        .post-image { max-width: 100%; border-radius: 8px; margin-bottom: 1rem; max-height: 400px; object-fit: contain; display: block;}
        
        .alert { padding: 1rem; border-radius: 6px; margin-bottom: 1rem; }
        .alert-success { background: #D1FAE5; color: #065F46; }
        .alert-danger { background: #FEE2E2; color: #DC2626; }
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
        List<Post> myPosts = postDAO.getPostsByUserId(user.getUserId());
    %>

    <header>
        <a href="index.jsp" class="logo">ForumHub</a>
        <div class="nav-links">
            <a href="index.jsp">Feed</a>
            <% if ("admin".equals(user.getRole())) { %>
                <a href="admin.jsp">Admin Dashboard</a>
            <% } %>
            <a href="logout" class="btn btn-danger">Logout</a>
        </div>
    </header>

    <div class="container">
        
        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Profile picture updated successfully!</div>
        <% } else if ("1".equals(request.getParameter("error"))) { %>
             <div class="alert alert-danger">Failed to update profile picture. Please try again.</div>
        <% } %>

        <div class="profile-header">
            <img src="<%= (user.getProfilePicUrl() != null && !user.getProfilePicUrl().isEmpty()) ? user.getProfilePicUrl() : "https://ui-avatars.com/api/?name=" + user.getUsername() + "&background=random" %>" alt="Profile Picture" class="profile-avatar">
            <h2><%= user.getUsername() %></h2>
            <p style="color: #6B7280; margin-bottom: 1.5rem;"><%= user.getEmail() %> • Role: <%= user.getRole() %></p>
            
            <form action="ProfileServlet" method="POST" enctype="multipart/form-data" style="max-width: 400px; margin: 0 auto; background: #f9fafb; padding: 1rem; border-radius: 8px; border: 1px dashed var(--border);">
                <input type="hidden" name="action" value="uploadPic">
                <div class="form-group" style="text-align: left;">
                    <label style="font-size: 0.875rem; color: #4B5563; display:block; margin-bottom:0.25rem; font-weight:500;">Update Profile Picture</label>
                    <input type="file" name="profilePic" class="form-control" accept="image/*" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Upload New Picture</button>
            </form>
        </div>

        <h3 style="margin-bottom: 1rem; border-bottom: 2px solid var(--border); padding-bottom: 0.5rem;">My Discussions (<%= myPosts.size() %>)</h3>

        <div class="feed">
            <% if (myPosts != null && !myPosts.isEmpty()) { 
                for (Post post : myPosts) {
            %>
                <div class="post-card">
                    <div class="post-header">
                        <div class="post-meta"><%= post.getCreatedDate() %></div>
                        <form action="PostServlet" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="deletePost">
                            <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                            <button type="submit" class="btn btn-danger" style="padding: 0.25rem 0.5rem; font-size: 0.875rem;" onclick="return confirm('Are you sure you want to delete this post?');">Delete</button>
                        </form>
                    </div>
                    
                    <h3 class="post-title"><a href="index.jsp" style="color: var(--text-color); text-decoration: none;"><%= post.getTitle() %></a></h3>
                    <div class="post-content"><%= post.getContent() %></div>
                    
                    <% if (post.getImageUrl() != null && !post.getImageUrl().isEmpty()) { %>
                        <img src="<%= post.getImageUrl() %>" alt="Post Request Attachment" class="post-image">
                    <% } %>
                    
                    <div class="post-meta" style="margin-top: 1rem;">
                        <%= (post.getComments() != null) ? post.getComments().size() : 0 %> replies
                    </div>
                </div>
            <%  }
               } else { %>
                <div style="text-align: center; padding: 3rem; color: #6B7280; background: white; border-radius: 12px;">
                    <h3>You haven't posted anything yet.</h3>
                    <a href="index.jsp" class="btn" style="display:inline-block; margin-top: 1rem;">Start a Discussion</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
