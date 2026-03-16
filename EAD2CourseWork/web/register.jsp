<%-- 
    Document   : register
    Created on : 14 Mar 2026, 22:28:24
    Author     : gayan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>
        <style>
            * {
                box-sizing: border-box;
            }

            html,
            body {
                height: 100%;
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
                background: #f2f2f2;
            }

            .register-container {
                width: 100%;
                max-width: 400px;
                margin: 80px auto;
                padding: 30px 25px;
                background: #fff;
                border: 1px solid #c4c4c4;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
                border-radius: 5px;
            }

            .register-container .logo img {
                width: 150px;
                height: auto;

            }

            h2 {
                text-align: center;
                margin-bottom: 20px;
                color: #333;
            }

            label {
                display: block;
                margin-top: 10px;
                color: #333;
            }

            input[type="text"],
            input[type="password"],
            input[type="email"] {
                width: 100%;
                padding: 12px 15px;
                margin-top: 5px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            button {
                width: 100%;
                margin-top: 12px;
                padding: 12px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 15px;
            }

            button:hover {
                opacity: 0.85;
            }

            button[type="reset"] {
                background-color: #9e9e9e;
            }

            button[type="button"] {
                background-color: #2196F3;
            }
        </style>
        <link rel="stylesheet" type="text/css" href="css/popup.css">
    </head>
    <body 
        data-error="<%= session.getAttribute("error") != null ? session.getAttribute("error") : "" %>"
    >
        <% session.removeAttribute("error"); %>
        <form method="POST" action="register">
            <div class="register-container">
                <div class="logo" align="center">
                    <img src="images/LogoBG.png" alt="Logo" class="logo-image">
                </div>
                <h2>Register</h2>

                <label for="username">Username:</label>
                <input type="text" id="username" name="username">

                <label for="email">Email:</label>
                <input type="email" id="email" name="email">

                <label for="password">Password:</label>

                    <input type="password" id="password" name="password" required>

                    <label for="confirm_password">Confirm Password:</label>
                    <input type="password" id="confirm_password" name="confirm_password" required>

                    <button type="submit">Register</button>
                    <button type="button" onclick="window.location.href = 'login.jsp'">Login</button>
                    <button type="reset">Clear</button>
            </div>
        </form>
        <script src="js/popup.js"></script>
    </body>
</html>
