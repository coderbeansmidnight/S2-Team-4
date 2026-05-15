<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>

<%
String role = (String) session.getAttribute("role");
String currentFacultyId = (String) session.getAttribute("SJSU_ID");

if (currentFacultyId == null || role == null || !role.equals("faculty")) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String sjsuId = request.getParameter("sjsuId");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String preferredName = request.getParameter("preferredName");
String email = request.getParameter("email");
String department = request.getParameter("department");
String passwordValue = request.getParameter("password");
String confirmPassword = request.getParameter("confirmPassword");

String message = "";
boolean success = false;

if (sjsuId == null || firstName == null || lastName == null ||
    email == null || department == null || passwordValue == null ||
    confirmPassword == null || sjsuId.trim().isEmpty() ||
    firstName.trim().isEmpty() || lastName.trim().isEmpty() ||
    email.trim().isEmpty() || department.trim().isEmpty() ||
    passwordValue.trim().isEmpty() || confirmPassword.trim().isEmpty()) {

    message = "All required fields must be filled in.";

} else if (!passwordValue.equals(confirmPassword)) {

    message = "Password and confirm password do not match.";

} else {

    String user = "root";
    String password = "PASSWORD";

    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement userStmt = null;
    PreparedStatement facultyStmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/FinishInFour?useSSL=false&serverTimezone=UTC",
            "user",
            "password"
        );

        conn.setAutoCommit(false);

        String checkSql =
            "SELECT * FROM `User` " +
            "WHERE SJSU_ID = ? OR SJSU_Email_Address = ?";

        checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, sjsuId.trim());
        checkStmt.setString(2, email.trim());

        rs = checkStmt.executeQuery();

        if (rs.next()) {

            message = "A user with that SJSU ID or email already exists.";

        } else {

            String userSql =
                "INSERT INTO `User` " +
                "(SJSU_ID, Password, SJSU_Email_Address, First_Name, Last_Name, Preferred_Name) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

            userStmt = conn.prepareStatement(userSql);

            userStmt.setString(1, sjsuId.trim());
            userStmt.setString(2, passwordValue);
            userStmt.setString(3, email.trim());
            userStmt.setString(4, firstName.trim());
            userStmt.setString(5, lastName.trim());

            if (preferredName == null || preferredName.trim().isEmpty()) {
                userStmt.setNull(6, java.sql.Types.VARCHAR);
            } else {
                userStmt.setString(6, preferredName.trim());
            }

            userStmt.executeUpdate();

            String facultySql =
                "INSERT INTO Faculty " +
                "(SJSU_ID, Department) " +
                "VALUES (?, ?)";

            facultyStmt = conn.prepareStatement(facultySql);

            facultyStmt.setString(1, sjsuId.trim());
            facultyStmt.setString(2, department.trim());

            facultyStmt.executeUpdate();

            conn.commit();

            success = true;
            message = "Faculty account created successfully.";
        }

    } catch (Exception e) {

        if (conn != null) {
            try {
                conn.rollback();
            } catch (Exception rollbackError) {
            }
        }

        message = "Error: " + e.getMessage();

    } finally {

        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (checkStmt != null) checkStmt.close(); } catch (Exception e) {}
        try { if (userStmt != null) userStmt.close(); } catch (Exception e) {}
        try { if (facultyStmt != null) facultyStmt.close(); } catch (Exception e) {}

        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (Exception e) {
            }
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Add Faculty Status</title>
<link rel="stylesheet"
    href="<%=request.getContextPath()%>/css/studentHome.css">
</head>

<body>

<div class="page-container">
    <div class="home-card">

        <h1>Add Faculty Status</h1>

        <p class="subtitle">
            Your faculty account request has been processed
        </p>

        <div class="section">

            <p class="message"><%=message%></p>

            <div class="action-row">

                <%
                if (success) {
                %>

                    <a href="facultyHome.jsp"
                        class="secondary-btn create-btn">
                        Back to Faculty Home
                    </a>

                    <a href="createFaculty.jsp"
                        class="secondary-btn">
                        Add Another Faculty
                    </a>

                <%
                } else {
                %>

                    <a href="createFaculty.jsp"
                        class="secondary-btn create-btn">
                        Try Again
                    </a>

                    <a href="facultyHome.jsp"
                        class="secondary-btn">
                        Back to Faculty Home
                    </a>

                <%
                }
                %>

            </div>

        </div>

    </div>
</div>

</body>
</html>
