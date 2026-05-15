<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
String role = (String) session.getAttribute("role");
String facultyId = (String) session.getAttribute("SJSU_ID");

if (facultyId == null || role == null || !role.equals("faculty")) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
<title>Add Faculty</title>
<link rel="stylesheet"
    href="<%=request.getContextPath()%>/css/studentHome.css">
</head>

<body>

<div class="page-container">
    <div class="home-card">

        <h1>Add Faculty</h1>
        <p class="subtitle">Create a new faculty account</p>

        <%
        if (error != null) {
        %>
            <p class="error"><%=error%></p>
        <%
        }
        %>

        <div class="section">

            <form method="post" action="createFacultyProcess.jsp">

                <label>SJSU ID:</label>
                <br>
                <input type="text" name="sjsuId" required>

                <br>
                <br>

                <label>First Name:</label>
                <br>
                <input type="text" name="firstName" required>

                <br>
                <br>

                <label>Last Name:</label>
                <br>
                <input type="text" name="lastName" required>

                <br>
                <br>

                <label>Preferred Name:</label>
                <br>
                <input type="text" name="preferredName">

                <br>
                <br>

                <label>SJSU Email Address:</label>
                <br>
                <input type="email" name="email" required>

                <br>
                <br>

                <label>Department:</label>
                <br>
                <input type="text" name="department" required>

                <br>
                <br>

                <label>Password:</label>
                <br>
                <input type="password" name="password" required>

                <br>
                <br>

                <label>Confirm Password:</label>
                <br>
                <input type="password" name="confirmPassword" required>

                <br>
                <br>

                <input type="submit" value="Add Faculty"
                    class="secondary-btn create-btn">

                <a href="facultyHome.jsp" class="secondary-btn">
                    Cancel
                </a>

            </form>

        </div>

    </div>
</div>

</body>
</html>
