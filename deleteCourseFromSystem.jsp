<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
String role = (String) session.getAttribute("role");
String facultyId = (String) session.getAttribute("SJSU_ID");

if (facultyId == null || role == null || !role.equals("faculty")) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String searchQuery = request.getParameter("search");

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String deleteId = request.getParameter("deleteId");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/finishinfour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
            "root",
            "FoxyDoxy12!"
        );

        ps = conn.prepareStatement("DELETE FROM Course WHERE Course_ID = ?");
        ps.setString(1, deleteId);

        ps.executeUpdate();

        response.sendRedirect("deleteCourseFromSystem.jsp?msg=deleted");
        return;

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
    <title>Delete Courses</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/studentHome.css">

    <script>
        function confirmDelete(courseId) {
            let confirmAction = confirm("Are you sure you want to delete course " + courseId + "? This cannot be undone.");
            if (confirmAction) {
                document.getElementById("deleteForm-" + courseId).submit();
            }
        }
    </script>
</head>

<body>

<div class="page-container">
    <div class="home-card">

        <h1>Delete Courses</h1>

        <div class="section">
            <form method="get" action="deleteCourseFromSystem.jsp">
                <input type="text" name="search"
                       placeholder="Search by course name or ID"
                       value="<%= searchQuery != null ? searchQuery : "" %>">
                <button type="submit" class="secondary-btn">Search</button>
            </form>
        </div>

        <div class="section">

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
                    	  "FROM Course " +
                    	  "WHERE Name LIKE ? OR Course_ID LIKE ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchQuery.trim() + "%");
                    ps.setString(2, "%" + searchQuery.trim() + "%");
                } else {
                    sql = "SELECT * FROM course";
                    ps = conn.prepareStatement(sql);
                }

                rs = ps.executeQuery();
            %>

            <table border="1" cellpadding="10" style="width:100%; background:white;">
                <tr>
                    <th>Course ID</th>
                    <th>Name</th>
                    <th>Credits</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>

                <%
                boolean hasData = false;

                while (rs.next()) {
                    hasData = true;

                    String courseId = rs.getString("Course_ID");
                %>

                <tr>
                    <td><%= courseId %></td>
                    <td><%= rs.getString("Name") %></td>
                    <td><%= rs.getInt("Number_Of_Credits") %></td>
                    <td><%= rs.getString("Description") %></td>

                    <td>

                        <form id="deleteForm-<%=courseId%>" method="post"
                              action="deleteCourseFromSystem.jsp"
                              style="display:inline;">

                            <input type="hidden" name="deleteId" value="<%= courseId %>">

                            <button type="button"
                                    class="secondary-btn"
                                    style="background:red; color:white;"
                                    onclick="confirmDelete('<%=courseId%>')">

                                Delete
                            </button>

                        </form>

                    </td>
                </tr>

                <%
                }

                if (!hasData) {
                %>
                <tr>
                    <td colspan="5">No courses found.</td>
                </tr>
                <%
                }

                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
                %>

            </table>

        </div>

        <div class="section">
            <a href="facultyHome.jsp" class="secondary-btn">Back to Home</a>
        </div>

    </div>
</div>

</body>
</html>
