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
String studentId = (String) session.getAttribute("studentId");
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
            String dbUser = "root";
            String dbPassword = "Gopher41";

            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
                    dbUser,
                    dbPassword
                );

                String sql =
                    "SELECT B.Course_ID, B.Name, B.Number_of_Credits, B.Description, A.Notes " +
                    "FROM Course B " +
                    "JOIN Adds A ON B.Course_ID = A.Course_ID " +
                    "WHERE A.SJSU_ID = ?";

                stmt = con.prepareStatement(sql);
                stmt.setString(1, studentId);
                rs = stmt.executeQuery();

                if (!rs.isBeforeFirst()) {
            %>
                <p class="message">You are not enrolled in any classes yet.</p>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Course ID</th>
                            <th>Course Name</th>
                            <th>Credits</th>
                            <th>Description</th>
                            <th>Your Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        while (rs.next()) {
                            String notes = rs.getString("Notes");
                            if (notes == null) notes = "";
                        %>
                        <tr>
                            <td><%= rs.getString("Course_ID") %></td>
                            <td><%= rs.getString("Name") %></td>
                            <td><%= rs.getString("Number_of_Credits") %></td>
                            <td><%= rs.getString("Description") %></td>

                            <td>
                                <form method="post" action="updateNotes.jsp" style="display:flex; gap:8px;">
                                    <input type="text"
                                           name="notes"
                                           class="notes-input"
                                           placeholder="Add notes..."
                                           value="<%= notes %>" />

                                    <input type="hidden"
                                           name="courseId"
                                           value="<%= rs.getString("Course_ID") %>" />

                                    <input type="submit"
                                           value="Save"
                                           class="save-btn" />
                                </form>
                            </td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            <%
                }

            } catch (Exception e) {
            %>
                <p class="message">Error loading classes: <%= e.getMessage() %></p>
            <%
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
            %>
        </div>

        <div class="section">
            <h2>Actions</h2>
            <div class="action-row">
                <a href="selectCourses.jsp" class="secondary-btn create-btn">Add Courses</a>
                <a href="validateCourses.jsp" class="secondary-btn create-btn">Validate Core Courses</a>
                <a href="semesters.jsp" class="secondary-btn create-btn">Plan Semesters</a>
                <a href="viewSemesterPlan.jsp" class="secondary-btn">View Semester Plan</a>
                <a href="deleteCourses.jsp" class="secondary-btn">Delete Courses</a>
                <a href="login.jsp" class="secondary-btn">Logout</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>