import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/studentHome")
public class studentHomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");

        List<String[]> currentClasses = new ArrayList<>();
        List<String[]> searchResults = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            if (search != null && !search.trim().isEmpty()) {
                String searchSql =
                    "SELECT Course_ID, Course_name, Credits " +
                    "FROM cs_courses " +
                    "WHERE Course_ID LIKE ? OR Course_name LIKE ?";

                try (PreparedStatement ps = conn.prepareStatement(searchSql)) {
                    String keyword = "%" + search.trim() + "%";
                    ps.setString(1, keyword);
                    ps.setString(2, keyword);

                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        String[] row = new String[3];
                        row[0] = rs.getString("Course_ID");
                        row[1] = rs.getString("Course_name");
                        row[2] = String.valueOf(rs.getInt("Credits"));
                        searchResults.add(row);
                    }
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.setAttribute("currentClasses", currentClasses);
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("searchTerm", search);

        request.getRequestDispatcher("/studentHome.jsp").forward(request, response);
    }
}
