<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Semester Plan</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentHome.css">
</head>
<body>

<%
String studentId = (String) session.getAttribute("studentId");

if (studentId == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<div class="page-container">
    <div class="home-card">

        <h1>Your Semester Plan</h1>
        <p class="subtitle">Courses organized by semester</p>

        <%
        String user = "root";
        String password = "Gopher41";

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        int totalCredits = 0;
        int semesterCredits = 0;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
                user,
                password
            );

            String sql =
                "SELECT sp.Semester, c.Course_ID, c.Name, c.Number_of_Credits, c.Description " +
                "FROM SemesterPlan sp " +
                "JOIN Course c ON sp.Course_ID = c.Course_ID " +
                "WHERE sp.SJSU_ID = ? " +
                "ORDER BY sp.Semester, c.Course_ID";

            stmt = con.prepareStatement(sql);
            stmt.setString(1, studentId);
            rs = stmt.executeQuery();

            int currentSemester = -1;
            boolean hasPlan = false;

            while (rs.next()) {
                hasPlan = true;

                int semester = rs.getInt("Semester");
                int credits = rs.getInt("Number_of_Credits");

                totalCredits += credits;

                if (semester != currentSemester) {
                    if (currentSemester != -1) {
        %>
                        </tbody>
                    </table>
                    <p class="message">Semester <%= currentSemester %> Credits: <strong><%= semesterCredits %></strong></p>
                </div>
        <%
                    }

                    currentSemester = semester;
                    semesterCredits = 0;
        %>
                <div class="section">
                    <h2>Semester <%= currentSemester %></h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Course ID</th>
                                <th>Name</th>
                                <th>Credits</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
        <%
                }

                semesterCredits += credits;
        %>
                            <tr>
                                <td><%= rs.getString("Course_ID") %></td>
                                <td><%= rs.getString("Name") %></td>
                                <td><%= rs.getString("Number_of_Credits") %></td>
                                <td><%= rs.getString("Description") %></td>
                                <td>
                                    <form method="post" action="deleteSemesterCourse.jsp">
                                        <input type="hidden" name="courseId" value="<%= rs.getString("Course_ID") %>">
                                        <input type="hidden" name="semester" value="<%= semester %>">
                                        <input type="submit" value="Delete" class="secondary-btn">
                                    </form>
                                </td>
                            </tr>
        <%
            }

            if (hasPlan) {
        %>
                        </tbody>
                    </table>
                    <p class="message">Semester <%= currentSemester %> Credits: <strong><%= semesterCredits %></strong></p>
                </div>

                <div class="section">
                    <h2>Plan Summary</h2>
                    <p class="message">Total Planned Credits: <strong><%= totalCredits %></strong></p>
                </div>
        <%
            } else {
        %>
                <div class="section">
                    <p class="message">You have not planned any semesters yet.</p>
                </div>
        <%
            }

        } catch(Exception e) {
        %>
            <div class="section">
                <p class="message">Error: <%= e.getMessage() %></p>
            </div>
        <%
        } finally {
            try { if (rs != null) rs.close(); } catch(Exception e) {}
            try { if (stmt != null) stmt.close(); } catch(Exception e) {}
            try { if (con != null) con.close(); } catch(Exception e) {}
        }
        %>

        <div class="section">
            <h2>Actions</h2>
            <div class="action-row">
                <a href="semesters.jsp" class="secondary-btn create-btn">Edit Plan</a>
                <a href="studentHome.jsp" class="secondary-btn">Back to Dashboard</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>