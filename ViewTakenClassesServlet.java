import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/viewTakenClasses")
public class ViewTakenClassesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String sjsuId = (String) session.getAttribute("sjsuId");

        if (sjsuId == null || sjsuId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<String[]> takenClasses = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            if (conn == null) {
                throw new ServletException("Database connection failed.");
            }

            String sql =
                "SELECT c.Course_ID, c.Course_name, c.Credits, uc.semester_taken, uc.grade " +
                "FROM user_courses uc " +
                "JOIN cs_courses c ON uc.course_id = c.Course_ID " +
                "WHERE uc.sjsu_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, sjsuId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String[] row = new String[5];
                        row[0] = rs.getString("Course_ID");
                        row[1] = rs.getString("Course_name");
                        row[2] = String.valueOf(rs.getInt("Credits"));
                        row[3] = rs.getString("semester_taken");
                        row[4] = rs.getString("grade");
                        takenClasses.add(row);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading taken classes.", e);
        }

        request.setAttribute("takenClasses", takenClasses);

        request.getRequestDispatcher("/ViewTakenClasses.jsp").forward(request, response);
    }
}
