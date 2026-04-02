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
    <link rel="stylesheet" type="text/css" href="css/popup.css">
</head>
<body 
    data-error="<%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : (session.getAttribute("error") != null ? session.getAttribute("error") : "") %>"
    data-success="<%= session.getAttribute("successMessage") != null ? session.getAttribute("successMessage") : "" %>"
>
    <% 
        request.removeAttribute("errorMessage"); 
        session.removeAttribute("error");
        session.removeAttribute("successMessage");
    %>
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
            <a href="logout" class="btn btn-danger" onclick="event.preventDefault(); showConfirm('Logout', 'Are you sure you want to logout?', () => window.location.href='logout')">Logout</a>
        </div>
    </header>

    <div class="container">

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
                            <form action="PostServlet" method="POST" style="margin:0;" id="deletePost_<%= post.getPostId() %>">
                                <input type="hidden" name="action" value="deletePost">
                                <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                                <button type="button" class="btn btn-danger" style="padding: 0.25rem 0.5rem; font-size: 0.875rem;" 
                                    onclick="showConfirm('Delete Post', 'Are you sure you want to delete this post?', () => document.getElementById('deletePost_<%= post.getPostId() %>').submit())">
                                    Delete
                                </button>
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
                                    // Parent comment eka witharai me pennanne
                                    if(c.getParentCommentId() == null || c.getParentCommentId() == 0){
                        %>
                            <div class="comment">
                                <div class="comment-header">
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <span class="comment-author"><%= c.getUsername() %></span>
                                        <span class="post-meta" style="font-size: 0.75rem;"><%= c.getCreatedDate() %></span>
                                    </div>
                                    <% if ("admin".equals(user.getRole()) || user.getUserId() == c.getUserId()) { %>
                                        <form action="PostServlet" method="POST" style="margin:0;" id="deleteComment_<%= c.getCommentId() %>">
                                            <input type="hidden" name="action" value="deleteComment">
                                            <input type="hidden" name="commentId" value="<%= c.getCommentId() %>">
                                            <button type="button" class="btn btn-danger" style="padding: 0.15rem 0.4rem; font-size: 0.7rem;" 
                                                onclick="showConfirm('Delete Comment', 'Are you sure you want to delete this comment?', () => document.getElementById('deleteComment_<%= c.getCommentId() %>').submit())">
                                                Delete
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                                <div><%= c.getCommentText() %></div>

                                <div style="margin-top: 8px; display: flex; gap: 15px; font-size: 0.85rem; align-items: center;">
                                    <form action="PostServlet" method="POST" style="margin:0; display: inline;">
                                        <input type="hidden" name="action" value="toggleLike">
                                        <input type="hidden" name="commentId" value="<%= c.getCommentId() %>">
                                        <button type="submit" style="background: none; border: none; color: #4F46E5; cursor: pointer; padding: 0; font-weight: 500;">
                                            Like (<%= c.getLikesCount() %>)
                                        </button>
                                    </form>
                                    <button onclick="document.getElementById('reply-form-<%= c.getCommentId() %>').style.display='flex'" style="background: none; border: none; color: #6B7280; cursor: pointer; padding: 0;">
                                        Reply
                                    </button>
                                </div>

                                <form id="reply-form-<%= c.getCommentId() %>" action="PostServlet" method="POST" class="comment-form" style="display: none; margin-top: 10px; margin-left: 20px;">
                                    <input type="hidden" name="action" value="addComment">
                                    <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                                    <input type="hidden" name="parentCommentId" value="<%= c.getCommentId() %>">
                                    <input type="text" name="commentText" class="form-control" placeholder="Write a reply..." required style="padding: 0.5rem; font-size: 0.9rem;">
                                    <button type="submit" class="btn" style="padding: 0.5rem 1rem;">Send</button>
                                </form>

                                <% if (c.getReplies() != null && !c.getReplies().isEmpty()) { %>
                                    <div style="margin-top: 10px; margin-left: 30px; border-left: 2px solid #E5E7EB; padding-left: 15px;">
                                        <% for (Comment reply : c.getReplies()) { %>
                                            <div class="comment" style="background: white; border: 1px solid #E5E7EB;">
                                                <div class="comment-header">
                                                    <div style="display: flex; align-items: center; gap: 10px;">
                                                        <span class="comment-author"><%= reply.getUsername() %></span>
                                                        <span class="post-meta" style="font-size: 0.75rem;"><%= reply.getCreatedDate() %></span>
                                                    </div>
                                                    <% if ("admin".equals(user.getRole()) || user.getUserId() == reply.getUserId()) { %>
                                                        <form action="PostServlet" method="POST" style="margin:0;" id="deleteComment_<%= reply.getCommentId() %>">
                                                            <input type="hidden" name="action" value="deleteComment">
                                                            <input type="hidden" name="commentId" value="<%= reply.getCommentId() %>">
                                                            <button type="button" class="btn btn-danger" style="padding: 0.15rem 0.4rem; font-size: 0.7rem;" 
                                                                onclick="showConfirm('Delete Reply', 'Are you sure you want to delete this reply?', () => document.getElementById('deleteComment_<%= reply.getCommentId() %>').submit())">
                                                                Delete
                                                            </button>
                                                        </form>
                                                    <% } %>
                                                </div>
                                                <div><%= reply.getCommentText() %></div>
                                                
                                                <div style="margin-top: 8px;">
                                                    <form action="PostServlet" method="POST" style="margin:0;">
                                                        <input type="hidden" name="action" value="toggleLike">
                                                        <input type="hidden" name="commentId" value="<%= reply.getCommentId() %>">
                                                        <button type="submit" style="background: none; border: none; color: #4F46E5; cursor: pointer; padding: 0; font-size: 0.85rem;">
                                                            Like (<%= reply.getLikesCount() %>)
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        <%          } // End of parent check
                                } 
                            } else { %>
                                <div style="color: #6B7280; font-size: 0.875rem;">No replies yet. Be the first to reply!</div>
                        <%  } %>
                        
                        <form action="PostServlet" method="POST" class="comment-form">
                            <input type="hidden" name="action" value="addComment">
                            <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                            <input type="text" name="commentText" class="form-control" placeholder="Write a comment..." required>
                            <button type="submit" class="btn">Comment</button>
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
    
    <script src="js/popup.js"></script>
</body>
</html>