<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
</head>
<body>

<%
String user = (String) session.getAttribute("user");

if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<h1>Welcome to the start of our app!!!</h1>

</body>
</html>