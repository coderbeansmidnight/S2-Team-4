<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Login</title>
</head>
<body>

<h1>Login</h1>

<%
String message = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    String dbUser = "root";
    String dbPassword = "Gopher41";

    if (email == null || password == null ||
        email.trim().isEmpty() || password.trim().isEmpty()) {
        message = "Email and password are required.";
    } else {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
                dbUser,
                dbPassword
            );

            String sql = "SELECT SJSU_ID, First_Name FROM User WHERE SJSU_Email_Address = ? AND Password = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            rs = stmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("studentId", rs.getString("SJSU_ID"));
                session.setAttribute("firstName", rs.getString("First_Name"));
                response.sendRedirect("studentHome.jsp");
                return;
            } else {
                message = "Invalid email or password.";
            }

        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
%>

<% if (!message.isEmpty()) { %>
    <p><%= message %></p>
<% } %>

<form method="post" action="login.jsp">
    SJSU Email: <input type="text" name="email" required><br><br>
    Password: <input type="password" name="password" required><br><br>
    <input type="submit" value="Login">
</form>

</body>
</html>