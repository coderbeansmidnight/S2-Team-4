<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Our Website</title>
</head>
<body>
<h1>FinishInFour Web Application</h1>

<table border="1">
<%--   <tr>
    <td>SJSU ID</td>
    <td>Email</td>
    <td>First Name</td>
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

            out.println(db + " database successfully opened.<br/><br/>");

            out.println("Initial entries in table \"User\": <br/>");

            Statement stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM User");
            
            

            while (rs.next()) {
         out.println("<tr>" + "<td>" +  rs.getInt(1) + "</td>"+ "<td>" +    rs.getString(2) + "</td>"+   "<td>" + rs.getString(3) + "</td>"  + "</tr>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch(SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        }
    %> --%>
<tr>
	            <td>Username</td>
	            <td><input type="text" name="username" /></td>
	        </tr>
	        <tr>
	            <td>Password</td>
	            <td><input type="password" name="password" /></td>
	        </tr>
</body>
</html>