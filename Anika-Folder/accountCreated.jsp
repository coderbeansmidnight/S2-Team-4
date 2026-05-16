<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Account Created</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentHome.css">
</head>
<body>

<%
String message = "";
boolean success = false;

String sjsuId = request.getParameter("sjsuId");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String preferredName = request.getParameter("preferredName");
String email = request.getParameter("email");
String passwordValue = request.getParameter("password");
String confirmPassword = request.getParameter("confirmPassword");

if (sjsuId == null || firstName == null || lastName == null || email == null || passwordValue == null || confirmPassword == null ||
    sjsuId.trim().isEmpty() || firstName.trim().isEmpty() || lastName.trim().isEmpty() ||
    email.trim().isEmpty() || passwordValue.trim().isEmpty() || confirmPassword.trim().isEmpty()) {

    message = "All required fields must be filled in.";

} else if (!passwordValue.equals(confirmPassword)) {
    message = "Password and confirm password do not match.";

} else {

    String user = "root";
    String password = "Gopher41";

    Connection con = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertStmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
            user,
            password
        );

        String checkSql = "SELECT * FROM User WHERE SJSU_ID = ? OR SJSU_Email_Address = ?";
        String insertSql = "INSERT INTO User (SJSU_ID, SJSU_Email_Address, First_Name, Last_Name, Password, Preferred_Name) VALUES (?, ?, ?, ?, ?, ?)";

        checkStmt = con.prepareStatement(checkSql);
        checkStmt.setString(1, sjsuId);
        checkStmt.setString(2, email);
        rs = checkStmt.executeQuery();

        if (rs.next()) {
            message = "An account with that SJSU ID or email already exists.";
        } else {
            insertStmt = con.prepareStatement(insertSql);
            insertStmt.setString(1, sjsuId);
            insertStmt.setString(2, email);
            insertStmt.setString(3, firstName);
            insertStmt.setString(4, lastName);
            insertStmt.setString(5, passwordValue);

            if (preferredName == null || preferredName.trim().isEmpty()) {
                insertStmt.setNull(6, java.sql.Types.VARCHAR);
            } else {
                insertStmt.setString(6, preferredName);
            }

            int rowsInserted = insertStmt.executeUpdate();

            if (rowsInserted > 0) {
                success = true;
                message = "Account created successfully.";
            } else {
                message = "Account creation failed.";
            }
        }

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception e) {}
        try { if (checkStmt != null) checkStmt.close(); } catch(Exception e) {}
        try { if (insertStmt != null) insertStmt.close(); } catch(Exception e) {}
        try { if (con != null) con.close(); } catch(Exception e) {}
    }
}
%>

<div class="page-container">
    <div class="home-card">

        <h1>Account Status</h1>
        <p class="subtitle">Your account request has been processed</p>

        <div class="section">

            <p class="message"><%= message %></p>

            <div class="action-row">
                <% if (success) { %>
                    <a href="login.jsp" class="secondary-btn create-btn">
                        Go to Login
                    </a>
                <% } else { %>
                    <a href="createAccount.jsp" class="secondary-btn create-btn">
                        Try Again
                    </a>
                    <a href="login.jsp" class="secondary-btn">
	                    Back to Login
	                </a>
                <% } %>

                
            </div>

        </div>

    </div>
</div>

</body>
</html>