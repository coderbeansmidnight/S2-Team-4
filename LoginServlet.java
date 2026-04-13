import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            if (con == null) {
                System.out.println("DB CONNECTION FAILED");
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
                return;
            }

            String query = "SELECT * FROM app_users WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("LOGIN SUCCESS");

                HttpSession session = request.getSession();
                session.setAttribute("user", username);

                response.sendRedirect(request.getContextPath() + "/studentHome");
            } else {
                System.out.println("LOGIN FAILED");
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
        }
    }
}
