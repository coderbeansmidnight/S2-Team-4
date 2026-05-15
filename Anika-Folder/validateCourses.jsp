<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Validate Courses</title>
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

String user = "root";
String password = "Gopher41";

Connection con = null;
PreparedStatement missingStmt = null;
PreparedStatement completedStmt = null;
ResultSet missingRs = null;
ResultSet completedRs = null;
%>

<div class="page-container">
    <div class="home-card">

        <h1>Validate Courses</h1>
        <p class="subtitle">Check your added courses against core degree requirements<%= firstName != null ? ", " + firstName : "" %></p>

        <div class="section">
            <h2>Missing Core Courses</h2>

            <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
                    user,
                    password
                );

                String missingSql =
                    "SELECT A.Course_ID, A.Name, A.Number_of_Credits " +
                    "FROM coreCourses B " +
                    "JOIN Course A ON B.Course_ID = A.Course_ID " +
                    "WHERE B.Course_ID NOT IN ( " +
                    "    SELECT C.Course_ID " +
                    "    FROM Adds C " +
                    "    WHERE C.SJSU_ID = ? " +
                    ")";

                missingStmt = con.prepareStatement(missingSql);
                missingStmt.setString(1, studentId);
                missingRs = missingStmt.executeQuery();

                if (!missingRs.isBeforeFirst()) {
            %>
                <p class="message">You have all required core courses in your schedule.</p>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Course ID</th>
                            <th>Course Name</th>
                            <th>Credits</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    while (missingRs.next()) {
                    %>
                        <tr>
                            <td><%= missingRs.getString("Course_ID") %></td>
                            <td><%= missingRs.getString("Name") %></td>
                            <td><%= missingRs.getString("Number_of_Credits") %></td>
                        </tr>
                    <%
                    }
                    %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>

        <div class="section">
            <h2>Core Courses Already Added</h2>

            <%
                String completedSql =
                    "SELECT c.Course_ID, c.Name, c.Number_of_Credits " +
                    "FROM coreCourses cc " +
                    "JOIN Course c ON cc.Course_ID = c.Course_ID " +
                    "WHERE cc.Course_ID IN ( " +
                    "    SELECT a.Course_ID " +
                    "    FROM Adds a " +
                    "    WHERE a.SJSU_ID = ? " +
                    ")";

                completedStmt = con.prepareStatement(completedSql);
                completedStmt.setString(1, studentId);
                completedRs = completedStmt.executeQuery();

                if (!completedRs.isBeforeFirst()) {
            %>
                <p class="message">You have not added any core courses yet.</p>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Course ID</th>
                            <th>Course Name</th>
                            <th>Credits</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    while (completedRs.next()) {
                    %>
                        <tr>
                            <td><%= completedRs.getString("Course_ID") %></td>
                            <td><%= completedRs.getString("Name") %></td>
                            <td><%= completedRs.getString("Number_of_Credits") %></td>
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
                <p class="message">Error: <%= e.getMessage() %></p>
            <%
            } finally {
                try { if (missingRs != null) missingRs.close(); } catch (Exception e) {}
                try { if (completedRs != null) completedRs.close(); } catch (Exception e) {}
                try { if (missingStmt != null) missingStmt.close(); } catch (Exception e) {}
                try { if (completedStmt != null) completedStmt.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
            %>
        </div>

        <div class="section">
            <h2>Actions</h2>
            <div class="action-row">
                <a href="studentHome.jsp" class="secondary-btn">Return to Dashboard</a>
                <a href="selectCourses.jsp" class="secondary-btn create-btn">Add Courses</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
