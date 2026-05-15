<%@ page import="java.sql.*" %>
<%
String studentId = (String) session.getAttribute("studentId");
String courseId = request.getParameter("courseId");
String notes = request.getParameter("notes");

Connection con = null;
PreparedStatement stmt = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
        "root",
        "Gopher41"
    );

    String sql = "UPDATE Adds SET Notes = ? WHERE SJSU_ID = ? AND Course_ID = ?";
    stmt = con.prepareStatement(sql);
    stmt.setString(1, notes);
    stmt.setString(2, studentId);
    stmt.setString(3, courseId);

    stmt.executeUpdate();

    response.sendRedirect("studentHome.jsp");

} catch (Exception e) {
    out.println("Error updating notes: " + e.getMessage());
} finally {
    try { if (stmt != null) stmt.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>
