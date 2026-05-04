<%@ page import="java.sql.*"%>

<%
String facultyId = (String) session.getAttribute("SJSU_ID");
String role = (String) session.getAttribute("role");

if (facultyId == null || role == null || !role.equals("faculty")) {
    response.sendRedirect("login.jsp");
    return;
}

String courseId = request.getParameter("courseId");
String courseNotes = request.getParameter("courseNotes");

if (courseId == null || courseNotes == null || courseNotes.trim().isEmpty()) {
    response.sendRedirect("facultyHome.jsp");
    return;
}

Connection conn = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/finishinfour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
        "root",
        "FoxyDoxy12!"
    );

    String sql =
        "INSERT INTO edits (SJSU_ID, Course_ID, CourseNotes) " +
        "VALUES (?, ?, ?) " +
        "ON DUPLICATE KEY UPDATE CourseNotes = VALUES(CourseNotes)";

    ps = conn.prepareStatement(sql);
    ps.setString(1, facultyId);
    ps.setString(2, courseId);
    ps.setString(3, courseNotes);

    ps.executeUpdate();

} catch (Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    if (ps != null) ps.close();
    if (conn != null) conn.close();
}

response.sendRedirect("facultyHome.jsp");
%>
