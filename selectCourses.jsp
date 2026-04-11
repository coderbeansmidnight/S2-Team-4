<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Select Courses</title>
</head>
<body>
<h1>Select Courses Previously Taken</h1>

<form action="processCourses.jsp" method="post">
<table border="1">
  <tr>
  	<td>Select</td>
    <td>Course ID</td>
    <td>Name</td>
    <td>Number of Credits</td>
  </tr>
    <%
     String db = "FinishInFour";
        String user; // assumes database name is the same as username
          user = "root";
        String password = "Gopher41";
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false",user, password);

            // out.println(db + " database successfully opened.<br/><br/>");

            // out.println("Initial entries in table \"Course\": <br/>");

            Statement stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM Course");

            while (rs.next()) {
            	out.println(
            		    "<tr>" +
            		    "<td><input type='checkbox' name='selectedCourses' value='" + rs.getString(1) + "'></td>" +
            		    "<td>" + rs.getString(1) + "</td>" +
            		    "<td>" + rs.getString(2) + "</td>" +
            		    "<td>" + rs.getString(3) + "</td>" +
            		    "</tr>"
            		);            
            }
            rs.close();
            stmt.close();
            con.close();
        } catch(SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        }
    %>
</table>
<br>
<input type="submit" value="Submit Selected Courses">
</form>
</body>
</html>