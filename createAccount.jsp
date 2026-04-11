<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Create Account</title>
</head>
<body>

<h2>Create Account</h2>

<% if (request.getParameter("error") != null) { %> <p style="color:red;">Error creating account. Please try again.</p>
<% } %>

<form action="<%= request.getContextPath() %>/createAccount" method="post">

<label>SJSU ID:</label>
<input type="text" name="sjsuId" required><br><br>

<label>First Name:</label>
<input type="text" name="firstName" required><br><br>

<label>Last Name:</label>
<input type="text" name="lastName" required><br><br>

<label>Preferred Name:</label>
<input type="text" name="preferredName"><br><br>

<label>SJSU Email:</label>
<input type="email" name="email" required><br><br>

<label>Major:</label>
<input type="text" name="major" required><br><br>

<label>Password:</label>
<input type="password" name="password" required><br><br>

<label>Confirm Password:</label>
<input type="password" name="confirmPassword" required><br><br>

<input type="submit" value="Create Account">

</form>

</body>
</html>
