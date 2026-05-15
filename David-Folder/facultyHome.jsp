<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

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

String searchQuery = request.getParameter("search");
String msg = request.getParameter("msg");
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

        <%
        if ("descUpdated".equals(msg)) {
        %>
            <p class="success">Description updated successfully.</p>
        <%
        }
        %>

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

        <div class="section">
            <h2>Courses</h2>

            <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            PreparedStatement notesStmt = null;
            ResultSet notesRs = null;

            HashMap<String, String> notesMap = new HashMap<String, String>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
                    "root",
                    "PASSWORD"
                );

                notesStmt = conn.prepareStatement(
                    "SELECT Course_ID, CourseNotes FROM Edits WHERE SJSU_ID = ?"
                );

                notesStmt.setString(1, facultyId);
                notesRs = notesStmt.executeQuery();

                while (notesRs.next()) {
                    notesMap.put(
                        notesRs.getString("Course_ID"),
                        notesRs.getString("CourseNotes")
                    );
                }

                if (notesRs != null) notesRs.close();
                if (notesStmt != null) notesStmt.close();

                String sql;

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    sql = "SELECT * " +
                          "FROM Course " +
                          "WHERE Name LIKE ? OR Course_ID LIKE ?";
                } else {
                    sql = "SELECT * FROM Course";
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
                    String description = rs.getString("Description");
                    String courseNotes = notesMap.get(courseId);
            %>

            <div class="section" style="margin-top: 20px;">
                <h2>
                    <%=courseName%>
                    (<%=courseId%>)
                </h2>

                <p>
                    <strong>Description:</strong>
                    <%=description%>
                </p>

                <a href="editDescription.jsp?courseId=<%=courseId%>"
                    class="secondary-btn create-btn">
                    Edit Description
                </a>

                <%
                if (courseNotes != null && !courseNotes.trim().isEmpty()) {
                %>
                    <p>
                        <strong>Course Notes:</strong>
                        <%=courseNotes%>
                    </p>
                <%
                } else {
                %>
                    <p>No notes yet.</p>
                <%
                }
                %>

                <form method="post"
                    action="<%=request.getContextPath()%>/handleEdit.jsp">

                    <input type="hidden" name="courseId" value="<%=courseId%>">

                    <label>Update Course Notes:</label><br>
                    <textarea name="courseNotes" rows="4" cols="50"></textarea>

                    <br>
                    <br>

                    <input type="submit" value="Update Notes"
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
                    <%=e.getMessage()%>
                </p>
            <%
            } finally {
                if (notesRs != null) notesRs.close();
                if (notesStmt != null) notesStmt.close();

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
                    Create Course
                </a>

                <a href="deleteCourseFromSystem.jsp" class="secondary-btn">
                    Delete Course
                </a>
            </div>
        </div>

        <div class="section">
            <div class="action-row">
                <a href="<%=request.getContextPath()%>/logout"
                    class="secondary-btn">
                    Logout
                </a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
