import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBConnection {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/login_app", "root", "FoxyDoxy12!");
    		System.out.println("connection created");
    		Statement stmt = con.createStatement();
    		return(con);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Connection con = null;
		return con;
    }
}