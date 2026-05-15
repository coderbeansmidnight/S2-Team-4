<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Delete Courses</title>
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

        <h1>Delete Courses</h1>
        <p class="subtitle">Select courses to remove from your schedule</p>

        <div class="section">
            <form action="processDeleteCourses.jsp" method="post">
                <table>
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>Course ID</th>
                            <th>Name</th>
                            <th>Number of Credits</th>
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
                                "SELECT B.Course_ID, B.Name, B.Number_of_Credits " +
                                "FROM Course B " +
                                "WHERE B.Course_ID IN (" +
                                "    SELECT A.Course_ID " +
                                "    FROM Adds A " +
                                "    WHERE A.SJSU_ID = ?" +
                                ")";

                            stmt = con.prepareStatement(sql);
                            stmt.setString(1, studentId);
                            rs = stmt.executeQuery();

                            if (!rs.isBeforeFirst()) {
                    %>
                        <tr>
                            <td colspan="4">You have no courses to delete.</td>
                        </tr>
                    <%
                            } else {
                                while (rs.next()) {
                    %>
                        <tr>
                            <td>
                                <input type="checkbox" name="selectedCourses" value="<%= rs.getString("Course_ID") %>">
                            </td>
                            <td><%= rs.getString("Course_ID") %></td>
                            <td><%= rs.getString("Name") %></td>
                            <td><%= rs.getString("Number_of_Credits") %></td>
                        </tr>
                    <%
                                }
                            }

                        } catch(SQLException e) {
                    %>
                        <tr>
                            <td colspan="4">SQLException caught: <%= e.getMessage() %></td>
                        </tr>
                    <%
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
                    <input type="submit" value="Delete Selected Courses" class="secondary-btn create-btn form-submit">
                    <a href="studentHome.jsp" class="secondary-btn">Back to Student Home</a>
                </div>
            </form>
        </div>

    </div>
</div>

</body>
</html>
