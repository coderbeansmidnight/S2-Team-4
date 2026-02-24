import java.sql.*;

public class jdbcTestJav {

	public static void main(String[] args) {
		
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		
		
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/Aguiniga", "root", "FoxyDoxy12!");
		System.out.println("connection created");
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery("select * from Student");
		while(rs.next()) 
			System.out.println(rs.getInt(1) + " " + rs.getString(2) + " " + rs.getString(3) + " Hello World");
			con.close();
		} catch(Exception e) {System.out.println(e);}
		
		}

}
