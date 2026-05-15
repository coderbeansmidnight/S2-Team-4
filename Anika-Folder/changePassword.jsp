<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Change Password</title>
</head>
<body>

<h1>Change Password</h1>

<%
String message = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
String sjsuId = request.getParameter("sjsuId");
String currentPassword = request.getParameter("currentPassword");
String newPassword = request.getParameter("newPassword");
String confirmPassword = request.getParameter("confirmPassword");

String dbUser = "root";
String dbPassword = "Gopher41";

if (sjsuId == null || currentPassword == null || newPassword == null || confirmPassword == null ||
    sjsuId.trim().isEmpty() || currentPassword.trim().isEmpty() ||
    newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
    message = "All required fields must be filled in.";
} else if (!newPassword.equals(confirmPassword)) {
    message = "New password and confirm password do not match.";
} else {
    Connection con = null;
    PreparedStatement checkStmt = null;
    PreparedStatement updateStmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
            dbUser,
            dbPassword
        );

        String checkSql = "SELECT Password FROM User WHERE SJSU_ID = ?";
        checkStmt = con.prepareStatement(checkSql);
        checkStmt.setString(1, sjsuId);
        rs = checkStmt.executeQuery();

        if (rs.next()) {
            String storedPassword = rs.getString("Password");

            if (!storedPassword.equals(currentPassword)) {
                message = "Current password is incorrect.";
            } else {
                String updateSql = "UPDATE User SET Password = ? WHERE SJSU_ID = ?";
                updateStmt = con.prepareStatement(updateSql);
                updateStmt.setString(1, newPassword);
                updateStmt.setString(2, sjsuId);

                int rowsUpdated = updateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    message = "Password changed successfully.";
                } else {
                    message = "Password update failed.";
                }
            }
        } else {
            message = "User not found.";
        }

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (checkStmt != null) checkStmt.close(); } catch (Exception e) {}
        try { if (updateStmt != null) updateStmt.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
}

}
%>

<% if (!message.isEmpty()) { %> <p><%= message %></p>
<% } %>

<form method="post" action="changePassword.jsp">
    SJSU ID: <input type="text" name="sjsuId" required><br><br>
    Current Password: <input type="password" name="currentPassword" required><br><br>
    New Password: <input type="password" name="newPassword" required><br><br>
    Confirm New Password: <input type="password" name="confirmPassword" required><br><br>
    <input type="submit" value="Change Password">
</form>

</body>
</html>
