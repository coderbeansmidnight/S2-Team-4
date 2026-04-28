<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Student Home</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentHome.css">
</head>
<body>

<%
String studentId = (String) session.getAttribute("SJSU_ID");
String firstName = (String) session.getAttribute("firstName");

if (studentId == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<div class="page-container">
    <div class="home-card">

        <h1>Student Dashboard</h1>
        <p class="subtitle">Welcome, <%= firstName %></p>

        <div class="section">
            <h2>Classes Taken</h2>

<%
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/finishinfour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
        "root",
        "FoxyDoxy12!"
    );

    String sql =
        "SELECT B.Course_ID, B.Name, B.Number_of_Credits " +
        "FROM Course B " +
        "WHERE B.Course_ID IN (" +
        "    SELECT A.Course_ID " +
        "    FROM adds A " +
        "    WHERE A.SJSU_ID = ?" +
        ")";

    stmt = con.prepareStatement(sql);
    stmt.setString(1, studentId);
    rs = stmt.executeQuery();
%>

<%
if (!rs.isBeforeFirst()) {
%>
    <p>You are not enrolled in any classes yet.</p>
<%
} else {
%>

    <table border="1" cellpadding="10" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>Course ID</th>
                <th>Course Name</th>
                <th>Credits</th>
            </tr>
        </thead>
        <tbody>

<%
    while (rs.next()) {
%>
        <tr>
            <td><%= rs.getString("Course_ID") %></td>
            <td><%= rs.getString("Name") %></td>
            <td><%= rs.getString("Number_of_Credits") %></td>
        </tr>
<%
    }
%>

        </tbody>
    </table>

<%
}
%>

<%
} catch (Exception e) {
%>
    <p>Error loading classes: <%= e.getMessage() %></p>
<%
} finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (con != null) con.close();
}
%>

        </div>

        <div class="section">
            <h2>Actions</h2>
            <div class="action-row">
                <a href="selectCourses.jsp" class="secondary-btn create-btn">Add Courses</a>
                <a href="validateCourses.jsp" class="secondary-btn create-btn">Validate Core Courses</a>
                <a href="<%= request.getContextPath() %>/logout" class="secondary-btn">Logout</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
