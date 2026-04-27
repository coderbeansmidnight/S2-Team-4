<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
String errorMessage = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/finishinfour?useSSL=false&serverTimezone=UTC",
            "root",
            "FoxyDoxy12!"
        );

        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, password);

        rs = ps.executeQuery();

        if (rs.next()) {
            HttpSession currentSession = request.getSession();

            String studentId = rs.getString("SJSU ID");
            String firstName = rs.getString("firstName");
            String preferredName = rs.getString("preferredName");

            currentSession.setAttribute("user", username);
            currentSession.setAttribute("studentId", studentId);
            currentSession.setAttribute("sjsuId", studentId);
            currentSession.setAttribute("firstName", firstName);
            currentSession.setAttribute("preferredName", preferredName);

            response.sendRedirect(request.getContextPath() + "/studentHome.jsp");
            return;
        } else {
            errorMessage = "Invalid username or password.";
        }

    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "Error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css">
</head>
<body>

<div class="page-container">
    <div class="login-container">
        <h2>Welcome to FinishInFour</h2>
        <p class="subtitle">Sign in to continue</p>

        <% if (!errorMessage.isEmpty()) { %>
            <p class="error"><%= errorMessage %></p>
        <% } %>

        <form action="<%= request.getContextPath() %>/login.jsp" method="post">
            <div class="input-group">
                <input type="text" name="username" placeholder="Username" required>
            </div>

            <div class="input-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <input type="submit" value="Login">
        </form>

        <div class="login-links">
            <a href="<%= request.getContextPath() %>/changePassword.jsp" class="secondary-btn">
                Forgot Password?
            </a>
            <a href="<%= request.getContextPath() %>/createAccount.jsp" class="secondary-btn create-btn">
                Create Account
            </a>
        </div>
    </div>
</div>

</body>
</html>
