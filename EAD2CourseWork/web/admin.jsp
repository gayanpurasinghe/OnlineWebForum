<%@page import="model.AdminDAO"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ForumHub</title>
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
        .btn-warning { background: #F59E0B; }
        .btn-warning:hover { background: #D97706; }
        .btn-success { background: #10B981; }
        .btn-success:hover { background: #059669; }
        
        .container { max-width: 1000px; margin: 2rem auto; padding: 0 1rem; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: var(--card-bg); padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); text-align: center; }
        .stat-card h3 { margin: 0; color: #6B7280; font-size: 1rem; font-weight: 500; }
        .stat-card .value { font-size: 2.5rem; font-weight: 700; color: var(--primary); margin: 0.5rem 0 0 0; }
        
        .table-container { background: var(--card-bg); border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { background: #F9FAFB; font-weight: 600; color: #4B5563; }
        tr:last-child td { border-bottom: none; }
        
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; vertical-align: middle; margin-right: 0.5rem; }
        
        .alert { padding: 1rem; border-radius: 6px; margin-bottom: 1rem; }
        .alert-success { background: #D1FAE5; color: #065F46; }
        .alert-danger { background: #FEE2E2; color: #DC2626; }
        
        .status-badge { padding: 0.25rem 0.5rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 600;}
        .badge-active { background: #D1FAE5; color: #065F46; }
        .badge-banned { background: #FEE2E2; color: #991B1B; }
    </style>
</head>
<body>
    <%-- Session Verification --%>
    <% 
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        AdminDAO adminDAO = new AdminDAO();
        int totalUsers = adminDAO.getTotalUsers();
        int totalPosts = adminDAO.getTotalActivePosts();
        List<User> userList = adminDAO.getAllUsers();
    %>

    <header>
        <a href="index.jsp" class="logo">ForumHub Admin</a>
        <div class="nav-links">
            <a href="index.jsp">Back to Forum</a>
            <a href="logout" class="btn btn-danger">Logout</a>
        </div>
    </header>

    <div class="container">
        
        <h2 style="margin-top:0;">Platform Overview</h2>
        
        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Action completed successfully!</div>
        <% } else if ("1".equals(request.getParameter("error"))) { %>
             <div class="alert alert-danger">An error occurred while processing your request.</div>
        <% } %>

        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Registered Users</h3>
                <p class="value"><%= totalUsers %></p>
            </div>
            <div class="stat-card">
                <h3>Active Posts</h3>
                <p class="value"><%= totalPosts %></p>
            </div>
        </div>

        <h3>User Management</h3>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Email</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (userList != null && !userList.isEmpty()) { 
                        for (User u : userList) {
                    %>
                    <tr>
                        <td>
                            <img src="<%= (u.getProfilePicUrl() != null && !u.getProfilePicUrl().isEmpty()) ? u.getProfilePicUrl() : "https://ui-avatars.com/api/?name=" + u.getUsername() + "&background=random" %>" class="user-avatar" alt="Avatar">
                            <strong><%= u.getUsername() %></strong>
                        </td>
                        <td><%= u.getEmail() %></td>
                        <td>
                            <% if (u.isBanned()) { %>
                                <span class="status-badge badge-banned">Banned</span>
                            <% } else { %>
                                <span class="status-badge badge-active">Active</span>
                            <% } %>
                        </td>
                        <td>
                            <form action="AdminServlet" method="POST" style="display:inline;">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <% if (u.isBanned()) { %>
                                    <input type="hidden" name="action" value="unban">
                                    <button type="submit" class="btn btn-success" style="padding: 0.35rem 0.75rem; font-size: 0.875rem;" onclick="return confirm('Are you sure you want to UNBAN this user?');">Unban</button>
                                <% } else { %>
                                    <input type="hidden" name="action" value="ban">
                                    <button type="submit" class="btn btn-warning" style="padding: 0.35rem 0.75rem; font-size: 0.875rem;" onclick="return confirm('Are you sure you want to BAN this user?');">Ban</button>
                                <% } %>
                            </form>
                            
                            <form action="AdminServlet" method="POST" style="display:inline; margin-left: 0.5rem;">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" class="btn btn-danger" style="padding: 0.35rem 0.75rem; font-size: 0.875rem;" onclick="return confirm('WARNING: This will permanently delete the user and all their posts/comments. Are you absolutely sure?');">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%  }
                       } else { %>
                       <tr><td colspan="4" style="text-align:center; padding: 2rem; color: #6B7280;">No registered users found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
