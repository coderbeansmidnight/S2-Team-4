<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
String errorMessage = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement userStmt = null;
    PreparedStatement facultyStmt = null;
    ResultSet userRs = null;
    ResultSet facultyRs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/finishinfour?useSSL=false&serverTimezone=UTC",
            "root",
            "FoxyDoxy12!"
        );

        // 1. Check user credentials
        String userSql = "SELECT * " +
        				 "FROM users " +
        				 "WHERE username = ? AND password = ?";
        userStmt = con.prepareStatement(userSql);
        userStmt.setString(1, username);
        userStmt.setString(2, password);

        userRs = userStmt.executeQuery();

        if (userRs.next()) {

            HttpSession currentSession = request.getSession();

            String sjsuId = userRs.getString("SJSU_ID");
            String firstName = userRs.getString("firstName");
            String preferredName = userRs.getString("preferredName");

            currentSession.setAttribute("user", username);
            currentSession.setAttribute("SJSU_ID", sjsuId);
            currentSession.setAttribute("firstName", firstName);
            currentSession.setAttribute("preferredName", preferredName);

            String facultySql = "SELECT * " +
            					"FROM faculty " +
            					"WHERE SJSU_ID = ?";
            facultyStmt = con.prepareStatement(facultySql);
            facultyStmt.setString(1, sjsuId);

            facultyRs = facultyStmt.executeQuery();

            if (facultyRs.next()) {

                currentSession.setAttribute("role", "faculty");
                response.sendRedirect(request.getContextPath() + "/facultyHome.jsp");
                return;

            } else {

                currentSession.setAttribute("role", "student");
                response.sendRedirect(request.getContextPath() + "/studentHome.jsp");
                return;
            }

        } else {
            errorMessage = "Invalid username or password.";
        }

    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "Error: " + e.getMessage();
    } finally {
        try { if (facultyRs != null) facultyRs.close(); } catch (Exception e) {}
        try { if (userRs != null) userRs.close(); } catch (Exception e) {}
        try { if (facultyStmt != null) facultyStmt.close(); } catch (Exception e) {}
        try { if (userStmt != null) userStmt.close(); } catch (Exception e) {}
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
