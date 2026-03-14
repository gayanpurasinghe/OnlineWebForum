<%-- 
    Document   : login
    Created on : 14 Mar 2026, 19:03:02
    Author     : gayan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>

        <form method="POST" action="">
            <div class="login-container">
                <div class="logo" align="center">
                    <img src="Logo.png" alt="Logo" class="logo-image">
                </div>
                <h2>Login</h2>

                <label for="username">Username:</label>
                <input type="text" id="username" name="username">

                <label for="password">Password:</label>
                <input type="password" id="password" name="password">

                <button type="submit">Login</button>
                <button type="button" onclick="">Register</button>
                <button type="reset">Clear</button>
            </div>


        </form>

    </body>
</html>
