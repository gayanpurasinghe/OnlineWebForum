<%@ page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Oops! An Error Occurred</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .error-container {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
        }
        h1 {
            color: #e74c3c;
            font-size: 48px;
            margin-bottom: 10px;
        }
        h2 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        p {
            font-size: 16px;
            line-height: 1.5;
            margin-bottom: 20px;
            color: #666;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }
        .btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <%
            Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
            String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
            String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
            
            if (statusCode == null && exception != null) {
                statusCode = 500;
                errorMessage = exception.getMessage();
            }
        %>
        <h1><%= statusCode != null ? statusCode : "Error" %></h1>
        <h2>Oops! Something went wrong.</h2>
        
        <% if (statusCode != null && statusCode == 404) { %>
            <p>We couldn't find the page you were looking for at <b><%= requestUri %></b>.</p>
        <% } else { %>
            <p>An unexpected error occurred while processing your request.</p>
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <p><b>Details:</b> <%= errorMessage %></p>
            <% } %>
        <% } %>
        
        <br>
        <a href="<%= request.getContextPath() %>/index.jsp" class="btn">Return to Home</a>
    </div>
</body>
</html>
