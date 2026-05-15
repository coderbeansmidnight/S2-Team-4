<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<%
String role = (String) session.getAttribute("role");
String facultyId = (String) session.getAttribute("SJSU_ID");

if (facultyId == null || role == null || !role.equals("faculty")) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String courseId = request.getParameter("courseId");

if (courseId == null || courseId.trim().isEmpty()) {
    response.sendRedirect("facultyHome.jsp");
    return;
}

String courseName = "";
String description = "";

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/FinishInFour?autoReconnect=true&useSSL=false&serverTimezone=UTC",
        "root",
        "PASSWORD"
    );

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newDescription = request.getParameter("description");

        String updateSql =
            "UPDATE Course " +
            "SET Description = ? " +
            "WHERE Course_ID = ?";

        ps = conn.prepareStatement(updateSql);

        ps.setString(1, newDescription);
        ps.setString(2, courseId);

        ps.executeUpdate();

        response.sendRedirect("facultyHome.jsp?msg=descUpdated");
        return;
    }

    String selectSql =
        "SELECT Name, Description " +
        "FROM Course " +
        "WHERE Course_ID = ?";

    ps = conn.prepareStatement(selectSql);

    ps.setString(1, courseId);

    rs = ps.executeQuery();

    if (rs.next()) {
        courseName = rs.getString("Name");
        description = rs.getString("Description");
    } else {
        response.sendRedirect("facultyHome.jsp");
        return;
    }

} catch (Exception e) {
%>
    <p class="error">
        Error:
        <%=e.getMessage()%>
    </p>
<%
} finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (conn != null) conn.close();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Description</title>
<link rel="stylesheet"
    href="<%=request.getContextPath()%>/css/studentHome.css">
</head>

<body>

<div class="page-container">
    <div class="home-card">

        <h1>Edit Description</h1>

        <p class="subtitle">
            Editing description for:
            <strong>
                <%=courseName%>
                (<%=courseId%>)
            </strong>
        </p>

        <div class="section">

            <form method="post"
                action="editDescription.jsp?courseId=<%=courseId%>">

                <label>Description:</label>
                <br>

                <textarea name="description" rows="6" cols="60"><%=description != null ? description : ""%></textarea>

                <br>
                <br>

                <input type="submit" value="Save Description"
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
