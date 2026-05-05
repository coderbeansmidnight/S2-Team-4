<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<%
String role = (String) session.getAttribute("role");
String facultyId = (String) session.getAttribute("SJSU_ID");
String firstName = (String) session.getAttribute("firstName");
String preferredName = (String) session.getAttribute("preferredName");

String displayName = firstName;
if (preferredName != null && !preferredName.trim().isEmpty()) {
    displayName = preferredName;
}

if (facultyId == null || role == null || !role.equals("faculty")) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String method = request.getMethod();

if ("POST".equalsIgnoreCase(method)) {

    String action = request.getParameter("action");

    if ("updateDescription".equals(action)) {

        String courseId = request.getParameter("courseId");
        String description = request.getParameter("description");

        Connection conn2 = null;
        PreparedStatement ps2 = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn2 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/finishinfour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
                "root",
                "FoxyDoxy12!"
            );

            String sql2 = "UPDATE course " +
            			  "SET Description = ? " +
            			  "WHERE Course_ID = ?";
            ps2 = conn2.prepareStatement(sql2);

            ps2.setString(1, description);
            ps2.setString(2, courseId);

            ps2.executeUpdate();

            response.sendRedirect("facultyHome.jsp?msg=descUpdated");
            return;

        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (ps2 != null) ps2.close();
            if (conn2 != null) conn2.close();
        }
    }
}

String searchQuery = request.getParameter("search");
%>

<!DOCTYPE html>
<html>
<head>
<title>Faculty Home</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/studentHome.css">
</head>

<body>

	<div class="page-container">
		<div class="home-card">

			<h1>Faculty Home</h1>
			<p class="subtitle">
				Welcome, Professor
				<%=displayName%>
			</p>

			<!-- SEARCH -->
			<div class="section">
				<h2>Search Courses</h2>

				<form method="get"
					action="<%=request.getContextPath()%>/facultyHome.jsp"
					class="search-form">

					<input type="text" name="search"
						placeholder="Search courses by name or ID"
						value="<%=searchQuery != null ? searchQuery : ""%>">

					<button type="submit">Search</button>
				</form>
			</div>

			<!-- COURSES -->
			<div class="section">
				<h2>Courses</h2>

				<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/finishinfour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
        "root",
        "FoxyDoxy12!"
    );

    String sql;
    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        sql = "SELECT * " +
    		  "FROM course " +
        	  "WHERE Name LIKE ? OR Course_ID LIKE ?";
    } else {
        sql = "SELECT * FROM course";
    }

    ps = conn.prepareStatement(sql);

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        ps.setString(1, "%" + searchQuery.trim() + "%");
        ps.setString(2, "%" + searchQuery.trim() + "%");
    }

    rs = ps.executeQuery();

    boolean hasCourses = false;

    while (rs.next()) {
        hasCourses = true;

        String courseId = rs.getString("Course_ID");
        String courseName = rs.getString("Name");
%>

				<div class="section" style="margin-top: 20px;">
					<h2><%=courseName%>
						(<%=courseId%>)
					</h2>

					<p>
						<strong>Description:</strong>
						<%= rs.getString("Description") %>
					</p>

					<form method="post" action="facultyHome.jsp">
						<input type="hidden" name="action" value="updateDescription">
						<input type="hidden" name="courseId" value="<%=courseId%>">

						<label>Edit Description:</label><br>
						<textarea name="description" rows="3" cols="50"></textarea>
						<br>
						<br> <input type="submit" value="Update Description"
							class="secondary-btn create-btn">
					</form>

					<%
PreparedStatement editStmt = null;
ResultSet editRs = null;

try {
    editStmt = conn.prepareStatement("SELECT CourseNotes FROM edits WHERE Course_ID = ? AND SJSU_ID = ?");
    editStmt.setString(1, courseId);
    editStmt.setString(2, facultyId);

    editRs = editStmt.executeQuery();

    if (editRs.next()) {
%>
					<p>
						<strong>Course Notes:</strong>
						<%=editRs.getString("CourseNotes")%>
					</p>
					<%
    } else {
%>
					<p>No notes yet.</p>
					<%
    }

} finally {
    if (editRs != null) editRs.close();
    if (editStmt != null) editStmt.close();
}
%>

					<form method="post"
						action="<%=request.getContextPath()%>/handleEdit.jsp">

						<input type="hidden" name="courseId" value="<%=courseId%>">

						<label>Update Course Notes:</label><br>
						<textarea name="courseNotes" rows="4" cols="50"></textarea>

						<br>
						<br> <input type="submit" value="Update Notes"
							class="secondary-btn create-btn">
					</form>

				</div>

				<%
    }

    if (!hasCourses) {
%>
				<p>No courses found.</p>
				<%
    }

} catch (Exception e) {
%>
				<p class="error">
					Error:
					<%=e.getMessage()%></p>
				<%
} finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (conn != null) conn.close();
}
%>

			</div>

			<div class="section">
				<h2>Course Management</h2>
				<div class="action-row">

					<a href="createCourse.jsp" class="secondary-btn create-btn">
						Create Course </a> <a href="deleteCourseFromSystem.jsp"
						class="secondary-btn"> Delete Course </a>

				</div>
			</div>

			<div class="section">
				<div class="action-row">
					<a href="<%= request.getContextPath() %>/logout"
						class="secondary-btn">Logout</a>
				</div>
			</div>

		</div>
	</div>

</body>
</html>
