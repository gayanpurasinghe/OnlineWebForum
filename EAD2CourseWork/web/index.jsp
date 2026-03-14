<%-- 
    Document   : index
    Created on : 14 Mar 2026, 18:35:13
    Author     : gayan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%-- Session Verification --%>
        <% model.User user = (model.User) session.getAttribute("user");
           if (user == null) {
               response.sendRedirect("login.jsp");
           } else {
        %>
            <h1>Welcome to the Forum, <%= user.getUsername() %>!</h1>
            <p>You are logged in as: <%= user.getRole() %></p>
            
            <%-- Simple Navigation --%>
            <nav>
                <a href="index.jsp">Home</a> | 
                <a href="logout">Logout</a>
            </nav>

            <hr>
            <h2>Latest Topics</h2>
            <p>Topics will be displayed here...</p>

        <% } %>
    </body>
</html>
