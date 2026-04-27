<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Select Courses</title>
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

        <h1>Add Courses</h1>
        <p class="subtitle">Select courses to add to your schedule</p>

        <div class="section">
            <form action="processCourses.jsp" method="post">
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
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",
                                user,
                                password
                            );

                            stmt = con.createStatement();
                            rs = stmt.executeQuery("SELECT * FROM Course");

                            while (rs.next()) {
                    %>
                        <tr>
                            <td>
                                <input type="checkbox" name="selectedCourses" value="<%= rs.getString(1) %>">
                            </td>
                            <td><%= rs.getString(1) %></td>
                            <td><%= rs.getString(2) %></td>
                            <td><%= rs.getString(3) %></td>
                        </tr>
                    <%
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
                    <input type="submit" value="Submit Selected Courses" class="secondary-btn create-btn">
                    <a href="studentHome.jsp" class="secondary-btn">Back to Student Home</a>
                </div>
            </form>
        </div>

    </div>
</div>

</body>
</html>