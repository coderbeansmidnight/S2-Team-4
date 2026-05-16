<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Guest Home</title>
<link rel="stylesheet"
	href="<%= request.getContextPath() %>/css/studentHome.css">
</head>

<body>

	<div class="page-container">
		<div class="home-card">

			<h1>Guest Dashboard</h1>
			<p class="subtitle">Welcome, Guest</p>

			<div class="section">
				<h2>Available Classes</h2>

				<%
            String searchQuery = request.getParameter("search");
            
            String dbUser = "root";
            String dbPassword = "PASSWORD";
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
                    dbUser,
                    dbPassword
                );

                String sql;

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    sql = "SELECT * " +
                          "FROM Course " +
                          "WHERE Name LIKE ? OR Course_ID LIKE ?";
                    stmt = con.prepareStatement(sql);
                    stmt.setString(1, "%" + searchQuery.trim() + "%");
                    stmt.setString(2, "%" + searchQuery.trim() + "%");
                } else {
                    sql = "SELECT * FROM Course";
                    stmt = con.prepareStatement(sql);
                }

                rs = stmt.executeQuery();
            %>

				<form method="get" action="guestHome.jsp" class="search-form">
					<input type="text" name="search"
						placeholder="Search courses by name or ID"
						value="<%= searchQuery != null ? searchQuery : "" %>">

					<button type="submit" class="secondary-btn">Search</button>
				</form>

				<br>

				<table border="1" cellpadding="10"
					style="width: 100%; background: white;">
					<tr>
						<th>Course ID</th>
						<th>Course Name</th>
						<th>Credits</th>
						<th>Description</th>
					</tr>

					<%
                boolean hasCourses = false;

                while (rs.next()) {
                    hasCourses = true;
                %>

					<tr>
						<td><%= rs.getString("Course_ID") %></td>
						<td><%= rs.getString("Name") %></td>
						<td><%= rs.getInt("Number_Of_Credits") %></td>
						<td><%= rs.getString("Description") %></td>
					</tr>

					<%
                }
                if (!hasCourses) {
                %>
					<tr>
						<td colspan="4">No courses found.</td>
					</tr>

					<%
                }
                %>

				</table>

				<%
            } catch (Exception e) {
            %>

				<p class="message">
					Error loading classes:
					<%= e.getMessage() %>
				</p>

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
					<a href="login.jsp" class="secondary-btn"> Back to Login </a>
				</div>
			</div>

		</div>
	</div>

</body>
</html>
