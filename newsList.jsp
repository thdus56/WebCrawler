<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>
<html>
<head>
</head>
<body>
<%
	// jdbc 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rset = null;
%>
	<center>기사 목록</center><br>
	<table border=1>
	<tr>
		<td>언론사</td>
		<td>기사 제목</td>
		<td>날짜</td>
	</tr>
<%	
	try {
		conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc14", "root", "911120");
		stmt = conn.createStatement();
		rset = stmt.executeQuery("select * from TBL_ARTICLE;");
		
		String company = "";
		
		while(rset.next()) {
			out.print("<tr>");
			
			if (rset.getString("company").equals("fnnews")) {
				company = "파이낸셜뉴스";
			} else if (rset.getString("company").equals("hani")) {
				company = "한겨레";
			} else if (rset.getString("company").equals("hankyung")) {
				company = "한국경제";
			} else if (rset.getString("company").equals("ccdailynews")) {
				company = "충청일보";
			} else if (rset.getString("company").equals("herald")) {
				company = "헤럴드경제";
			}
			
			out.print("<td>"+company+"</td>");
			out.print("<td><a href='"+rset.getString("article_link")+"'>"+rset.getString("title")+"</a></td>");
			out.print("<td>"+rset.getString("write_date")+"</td>");
			out.print("<tr>");
		}
	
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
	</table>
</body>
</html>
