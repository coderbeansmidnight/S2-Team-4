<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
String role = (String) session.getAttribute("role");
String facultyId = (String) session.getAttribute("SJSU_ID");

if (facultyId == null || role == null || !role.equals("faculty")) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String method = request.getMethod();

if ("POST".equalsIgnoreCase(method)) {

    String courseId = request.getParameter("courseId");
    String courseName = request.getParameter("courseName");
    String credits = request.getParameter("credits");
    String description = request.getParameter("description");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/finishinfour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
            "root",
            "FoxyDoxy12!"
        );

        String sql = "INSERT INTO Course (Course_ID, Name, Number_Of_Credits, Description) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);

        ps.setString(1, courseId);
        ps.setString(2, courseName);
        ps.setInt(3, Integer.parseInt(credits));
        ps.setString(4, description);

        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("facultyHome.jsp?msg=courseCreated");
            return;
        }

    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Create Course</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/studentHome.css">
</head>

<body>

<div class="page-container">
    <div class="home-card">

        <h1>Create New Course</h1>

        <div class="section">

            <form method="post" action="createCourse.jsp">

                <label>Course ID:</label><br>
                <input type="text" name="courseId" required>
                <br><br>

                <label>Course Name:</label><br>
                <input type="text" name="courseName" required>
                <br><br>

                <label>Number of Credits:</label><br>
                <input type="number" name="credits" min="1" max="10" required>
                <br><br>

                <label>Description:</label><br>
                <textarea name="description" rows="5" cols="50"></textarea>
                <br><br>

                <input type="submit" value="Create Course" class="secondary-btn create-btn">

            </form>

        </div>

        <div class="section">
            <a href="facultyHome.jsp" class="secondary-btn">Back to Home</a>
        </div>

    </div>
</div>

</body>
</html>
