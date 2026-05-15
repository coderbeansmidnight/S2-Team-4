<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<%
String role = (String) session.getAttribute("role");
String facultyId = (String) session.getAttribute("SJSU_ID");

if (facultyId == null || role == null || !role.equals("faculty")) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return;
}

String deleteId = request.getParameter("deleteId");

if (deleteId == null || deleteId.trim().isEmpty()) {
	response.sendRedirect("deleteCourseFromSystem.jsp?msg=missingId");
	return;
}

String dbUser = "root";
String dbPassword = "PASSWORD";

Connection conn = null;
PreparedStatement ps = null;

try {
	Class.forName("com.mysql.cj.jdbc.Driver");

	conn = DriverManager.getConnection(
	"jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
	dbUser,
	dbPassword);

	ps = conn.prepareStatement("DELETE FROM Course WHERE Course_ID = ?");
	ps.setString(1, deleteId);

	ps.executeUpdate();

	response.sendRedirect("deleteCourseFromSystem.jsp?msg=deleted");
	return;

} catch (Exception e) {
	response.sendRedirect("deleteCourseFromSystem.jsp?msg=error");
	return;

} finally {
	if (ps != null)
		ps.close();
	if (conn != null)
		conn.close();
}
%>
