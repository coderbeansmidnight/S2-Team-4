<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

    <div class="login-container">
        <h2>Welcome to FinishInFour</h2>
        <p class="subtitle">Sign in to continue</p>

        <% if (request.getParameter("error") != null) { %>
            <p class="error">Invalid username or password</p>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="input-group">
                <input type="text" name="username" placeholder="Username" required>
            </div>

            <div class="input-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <input type="submit" value="Login">
        </form>

        <div class="login-links">
            <a href="<%= request.getContextPath() %>/changePassword.jsp" class="secondary-btn">Forgot Password?</a>
            <a href="<%= request.getContextPath() %>/createAccount.jsp" class="secondary-btn create-btn">Create Account</a>
        </div>
    </div>

</body>
</html>
