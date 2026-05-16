<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Plan Semesters</title>
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

        <h1>Semester Planner</h1>
        <p class="subtitle">Assign your remaining courses to semesters</p>

        <div class="section">
            <form action="processSemesters.jsp" method="post">

                <table>
                    <thead>
                        <tr>
                            <th>Course ID</th>
                            <th>Name</th>
                            <th>Credits</th>
                            <th>Semester</th>
                        </tr>
                    </thead>
                    <tbody>

                    <%
                        String user = "root";
                        String password = "Gopher41";

                        Connection con = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
                                user,
                                password
                            );

                            String sql =
                            	    "SELECT Course_ID, Name, Number_of_Credits " +
                            	    "FROM Course " +
                            	    "WHERE Course_ID NOT IN (" +
                            	    "    SELECT Course_ID FROM SemesterPlan WHERE SJSU_ID = ? " +
                            	    ")";

                            stmt = con.prepareStatement(sql);
                            stmt.setString(1, studentId);
                            rs = stmt.executeQuery();

                            if (!rs.isBeforeFirst()) {
                    %>
                        <tr>
                            <td colspan="4">No remaining courses</td>
                        </tr>
                    <%
                            } else {
                                while (rs.next()) {
                    %>
                        <tr>
                            <td><%= rs.getString("Course_ID") %></td>
                            <td><%= rs.getString("Name") %></td>
                            <td><%= rs.getString("Number_of_Credits") %></td>

                            <td>
                                <select name="semester_<%= rs.getString("Course_ID") %>">
                                    <option value="">-- Select --</option>
                                    <option value="1">Semester 1</option>
                                    <option value="2">Semester 2</option>
                                    <option value="3">Semester 3</option>
                                    <option value="4">Semester 4</option>
                                    <option value="5">Semester 5</option>
                                    <option value="6">Semester 6</option>
                                    <option value="7">Semester 7</option>
                                    <option value="8">Semester 8</option>
                                </select>
                            </td>
                        </tr>

                        <input type="hidden" name="courseIds" value="<%= rs.getString("Course_ID") %>">

                    <%
                                }
                            }

                        } catch(Exception e) {
                    %>
                        <tr>
                            <td colspan="4">Error: <%= e.getMessage() %></td>
                        </tr>
                    <%
                        } finally {
                            try { if (rs != null) rs.close(); } catch(Exception e) {}
                            try { if (stmt != null) stmt.close(); } catch(Exception e) {}
                            try { if (con != null) con.close(); } catch(Exception e) {}
                        }
                    %>

                    </tbody>
                </table>

                <br>

                <div class="action-row">
                    <input type="submit" value="Save Plan" class="secondary-btn create-btn">
                    <a href="studentHome.jsp" class="secondary-btn">Back</a>
                </div>

            </form>
        </div>

    </div>
</div>

</body>
</html>