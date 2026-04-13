<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>Student Home</title>
</head>
<body>

<div class="page-container">
    <div class="home-card">
        <h1>Student Dashboard</h1>
        <p class="subtitle">View your current classes and search for courses</p>

        <div class="section">
            <h2>Current Classes</h2>
            <%
                List currentClasses = (List) request.getAttribute("currentClasses");
                if (currentClasses != null && !currentClasses.isEmpty()) {
            %>
                <div class="course-list">
                    <%
                        for (Object obj : currentClasses) {
                            String[] c = (String[]) obj;
                    %>
                        <div class="course-box">
                            <h3><%= c[0] %></h3>
                            <p><strong>Course:</strong> <%= c[1] %></p>
                            <p><strong>Credits:</strong> <%= c[2] %></p>
                        </div>
                    <%
                        }
                    %>
                </div>
            <%
                } else {
            %>
                <p>You are not enrolled in any classes yet.</p>
            <%
                }
            %>
        </div>

        <div class="section">
            <h2>Search Classes</h2>

            <form action="<%= request.getContextPath() %>/studentHome" method="get" class="search-form">
                <input type="text" name="search" placeholder="Search by course ID or course name"
                       value="<%= request.getAttribute("searchTerm") != null ? request.getAttribute("searchTerm") : "" %>">
                <button type="submit">Search</button>
            </form>

            <%
                List searchResults = (List) request.getAttribute("searchResults");
                String searchTerm = (String) request.getAttribute("searchTerm");

                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            %>
                <div class="course-list">
                    <%
                        if (searchResults != null && !searchResults.isEmpty()) {
                            for (Object obj : searchResults) {
                                String[] c = (String[]) obj;
                    %>
                        <div class="course-box">
                            <h3><%= c[0] %></h3>
                            <p><strong>Course:</strong> <%= c[1] %></p>
                            <p><strong>Credits:</strong> <%= c[2] %></p>
                        </div>
                    <%
                            }
                        } else {
                    %>
                        <p>No classes matched your search.</p>
                    <%
                        }
                    %>
                </div>
            <%
                }
            %>
        </div>
    </div>
    <a href="<%= request.getContextPath() %>/logout" class="secondary-btn create-btn">Logout</a>    
</div>

</body>
</html>
