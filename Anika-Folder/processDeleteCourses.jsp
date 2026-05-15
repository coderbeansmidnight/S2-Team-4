<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Process Deleted Courses</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentHome.css">
</head>
<body>

<%
String studentId = (String) session.getAttribute("studentId");

if (studentId == null) {
    response.sendRedirect("login.jsp");
    return;
}

String[] selectedCourses = request.getParameterValues("selectedCourses");

String message = "";
int deletedCount = 0;

if (selectedCourses == null || selectedCourses.length == 0) {
    message = "No courses were selected.";
} else {

    String user = "root";
    String password = "Gopher41";

    Connection con = null;
    PreparedStatement deleteStmt = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
            user,
            password
        );

        String deleteSql = "DELETE FROM Adds WHERE SJSU_ID = ? AND Course_ID = ?";
        deleteStmt = con.prepareStatement(deleteSql);

        for (String courseId : selectedCourses) {
            deleteStmt.setString(1, studentId);
            deleteStmt.setString(2, courseId);
            deletedCount += deleteStmt.executeUpdate();
        }

        message = "Deleted " + deletedCount + " course(s) from your schedule.";

    } catch(Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        try { if (deleteStmt != null) deleteStmt.close(); } catch(Exception e) {}
        try { if (con != null) con.close(); } catch(Exception e) {}
    }
}
%>

<div class="page-container">
    <div class="home-card">

        <h1>Course Update</h1>
        <p class="subtitle">Your schedule has been updated</p>

        <div class="section">
            <p class="message"><%= message %></p>

            <div class="action-row">
                <a href="studentHome.jsp" class="secondary-btn">
                    Return to Dashboard
                </a>

                <a href="deleteCourses.jsp" class="secondary-btn create-btn">
                    Delete More Courses
                </a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
