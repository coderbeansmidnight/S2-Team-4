<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Process Courses</title>
</head>
<body>

<%
String studentId = (String) session.getAttribute("studentId");

if (studentId == null) {
    response.sendRedirect("login.jsp");
    return;
}

String[] selectedCourses = request.getParameterValues("selectedCourses");

if (selectedCourses == null || selectedCourses.length == 0) {
    out.println("<p>No courses were selected.</p>");
    out.println("<a href='selectCourses.jsp'>Go Back</a>");
    return;
}

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

    int addedCount = 0;
    int skippedCount = 0;

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

    out.println("<h2>Courses Processed</h2>");
    out.println("<p>Added " + addedCount + " course(s) to your schedule.</p>");

    if (skippedCount > 0) {
        out.println("<p>" + skippedCount + " course(s) were already in your schedule.</p>");
    }

    out.println("<a href='studentHome.jsp'>Return to Student Home</a>");

} catch(Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
} finally {
    try { if (checkStmt != null) checkStmt.close(); } catch(Exception e) {}
    try { if (insertStmt != null) insertStmt.close(); } catch(Exception e) {}
    try { if (con != null) con.close(); } catch(Exception e) {}
}
%>

</body>
</html>