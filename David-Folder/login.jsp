<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<%
String errorMessage = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String sjsuId = request.getParameter("sjsuId");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement userStmt = null;
    PreparedStatement facultyStmt = null;
    ResultSet userRs = null;
    ResultSet facultyRs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/FinishInFour?useSSL=false&serverTimezone=UTC",
            "root",
            "Gopher41"
        );

        String userSql =
            "SELECT * " +
            "FROM User " +
            "WHERE SJSU_ID = ? " +
            "AND Password = ?";

        userStmt = con.prepareStatement(userSql);
        userStmt.setString(1, sjsuId);
        userStmt.setString(2, password);

        userRs = userStmt.executeQuery();

        if (userRs.next()) {

            HttpSession currentSession = request.getSession();

            String firstName = userRs.getString("First_Name");
            String preferredName = userRs.getString("Preferred_Name");
            String email = userRs.getString("SJSU_Email_address");

            currentSession.setAttribute("SJSU_ID", sjsuId);
            currentSession.setAttribute("studentId", sjsuId);
            currentSession.setAttribute("firstName", firstName);
            currentSession.setAttribute("preferredName", preferredName);
            currentSession.setAttribute("email", email);

            String facultySql =
                "SELECT * " +
                "FROM Faculty " +
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
            errorMessage = "Invalid SJSU ID or password.";
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
<link rel="stylesheet"
    href="<%= request.getContextPath() %>/css/login.css">
</head>
<body>

    <div class="page-container">
        <div class="login-container">

            <h2>Welcome to FinishInFour</h2>
            <p class="subtitle">Sign in to continue</p>

            <% if (!errorMessage.isEmpty()) { %>
            <p class="error"><%= errorMessage %></p>
            <% } %>

            <form action="<%= request.getContextPath() %>/login.jsp"
                method="post">

                <div class="input-group">
                    <input type="text" name="sjsuId" placeholder="SJSU ID" required>
                </div>

                <div class="input-group">
                    <input type="password" name="password" placeholder="Password" required>
                </div>

                <input type="submit" value="Login">

            </form>

            <div class="login-links">
                <a href="<%= request.getContextPath() %>/changePassword.jsp"
                    class="secondary-btn"> Forgot Password? </a>

                <a href="<%= request.getContextPath() %>/createAccount.jsp"
                    class="secondary-btn create-btn"> Create Account </a>

                <a href="<%=request.getContextPath()%>/guestHome.jsp"
					class="secondary-btn"> Continue as Guest </a>
            </div>

        </div>
    </div>

</body>
</html>
