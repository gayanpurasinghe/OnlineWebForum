<%-- 
    Document   : success
    Created on : Mar 16, 2026, 12:16:02 AM
    Author     : My plus computers
--%>
   
 <%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Successful</title>
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
        .success-container {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            border-top: 5px solid #2ecc71; /* Green accent */
        }
        h1 {
            color: #2ecc71;
            font-size: 48px;
            margin-bottom: 10px;
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
    <div class="success-container">
        <h1>✔</h1>
        <h2>Registration Successful!</h2>
        <p>Welcome, <b>${username}</b>! Your account has been created successfully. You can now log in to access your profile.</p>
        
        <br>
        <a href="login.jsp" class="btn">Go to Login</a>
    </div>
</body>
</html>