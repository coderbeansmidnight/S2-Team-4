<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Taken Classes</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/studentHome.css">
</head>
<body>

<div class="page-container">
    <div class="home-card">

        <div style="display:flex; justify-content: space-between; align-items:center;">
            <h1>Classes You've Taken</h1>
            <a href="<%= request.getContextPath() %>/logout" class="secondary-btn">Logout</a>
        </div>

        <p class="subtitle">Here are all the classes you have completed + are currently taking</p>

        <%
            List takenClasses = (List) request.getAttribute("takenClasses");

            if (takenClasses != null && !takenClasses.isEmpty()) {
        %>
            <div class="course-list">
                <%
                    for (Object obj : takenClasses) {
                        String[] c = (String[]) obj;
                %>
                    <div class="course-box">
                        <h3><%= c[0] %></h3>
                        <p><strong>Course:</strong> <%= c[1] %></p>
                        <p><strong>Credits:</strong> <%= c[2] %></p>
                        <p><strong>Semester:</strong> <%= c[3] %></p>
                        <p><strong>Grade:</strong> <%= c[4] %></p>
                    </div>
                <%
                    }
                %>
            </div>
        <%
            } else {
        %>
            <p>No completed classes found.</p>
        <%
            }
        %>

        <div style="margin-top: 25px;">
            <a href="<%= request.getContextPath() %>/studentHome" class="secondary-btn">
                ← Back to Dashboard
            </a>
        </div>

    </div>
</div>

</body>
</html>
