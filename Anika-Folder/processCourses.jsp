<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Process Courses</title>
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
int addedCount = 0;
int skippedCount = 0;

if (selectedCourses == null || selectedCourses.length == 0) {
    message = "No courses were selected.";
} else {

    String user = "root";
    String password = "Gopher41";

    Connection con = null;
    PreparedStatement insertStmt = null;
    PreparedStatement checkStmt = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
            user,
            password
        );

        String checkSql = "SELECT * FROM Adds WHERE SJSU_ID = ? AND Course_ID = ?";
        String insertSql = "INSERT INTO Adds (SJSU_ID, Course_ID) VALUES (?, ?)";

        checkStmt = con.prepareStatement(checkSql);
        insertStmt = con.prepareStatement(insertSql);

        for (String courseId : selectedCourses) {
            checkStmt.setString(1, studentId);
            checkStmt.setString(2, courseId);

            ResultSet rs = checkStmt.executeQuery();

            if (!rs.next()) {
                insertStmt.setString(1, studentId);
                insertStmt.setString(2, courseId);
                insertStmt.executeUpdate();
                addedCount++;
            } else {
                skippedCount++;
            }

            rs.close();
        }

    } catch(Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        try { if (checkStmt != null) checkStmt.close(); } catch(Exception e) {}
        try { if (insertStmt != null) insertStmt.close(); } catch(Exception e) {}
        try { if (con != null) con.close(); } catch(Exception e) {}
    }
}
%>

<div class="page-container">
    <div class="home-card">

        <h1>Course Update</h1>
        <p class="subtitle">Your schedule has been updated</p>

        <div class="section">

            <% if (!message.isEmpty()) { %>
                <p class="message"><%= message %></p>
            <% } else { %>
                <p class="message">Added <%= addedCount %> course(s) to your schedule.</p>

                <% if (skippedCount > 0) { %>
                    <p class="message"><%= skippedCount %> course(s) were already added.</p>
                <% } %>
            <% } %>

            <div class="action-row">
                <a href="studentHome.jsp" class="secondary-btn">
                    Return to Dashboard
                </a>

                <a href="selectCourses.jsp" class="secondary-btn create-btn">
                    Add More Courses
                </a>
            </div>

        </div>

    </div>
</div>

</body>
</html>
