<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<!-- Ajax 사용을 위한 jquery -->
<script src="http://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- bootstrap CSS-->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<%
	// jdbc 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rset = null;

	String company = "";
	String click = "";
	if (request.getParameter("company") != null) {
		click = request.getParameter("company");
	}
	
	try {
		conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc14", "root", "911120");
		stmt = conn.createStatement();
		rset = stmt.executeQuery("select count(*) as count from TBL_ARTICLE where company = '"+click+"';");
		
		while(rset.next()) {
			out.print(rset.getString("count"));
		}
	
		rset.close();
		stmt.close();
		conn.close();
	
	} catch (SQLException e) {
		out.print(e);
	} catch (Exception e) {
		out.print(e);
	} finally {
		try { if (rset != null) rset.close(); } catch (Exception e) {};
		try { if (stmt != null) stmt.close(); } catch (Exception e) {};
		try { if (conn != null) conn.close(); } catch (Exception e) {};
	}
%>

</body>
</html>