<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, org.json.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%
	// 날짜 포맷
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	// 현재 시간 받아오는 변수
	java.util.Date today = new java.util.Date();
	
	// jdbc 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rset = null;
	
	String status = request.getParameter("status");
	String company = request.getParameter("company");
	String articleArray = request.getParameter("articleArray");
	
	String title = "";
	String article_link = "";
	String write_date = "";
	
	// status.jsp에서 넘어온 배열값을 jsonarray로 받음
	JSONArray array = new JSONArray(articleArray);
	
	try {
		// Connection 객체 생성
		conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc14", "root", "911120");
		// Statement 객체 생성
		stmt = conn.createStatement();
		
		stmt.execute("delete from TBL_ARTICLE where write_date != '"+sdf.format(today)+"'");
		
		for (int i = 0; i < array.length(); i++) {
			// jsonarray를 하나씩 jsonobject로 받음
			JSONObject oneNews = array.getJSONObject(i);
			
			// 작은 따옴표 치환
			title = oneNews.getString("title").replaceAll("'", "&#39;");
			article_link = oneNews.getString("article_link");
			write_date = oneNews.getString("write_date");
			
			// PK가 중복이면 제목만 업데이트
			stmt.execute("insert TBL_ARTICLE(company, title, article_link, write_date)"
						+"values ('"+company+"', '"+title+"', '"+article_link+"', '" + write_date +"')"
						+"on duplicate key update title='"+title+"';");
		}
	} catch (SQLException e) {
		out.print(e);
	} catch (Exception e) {
		out.print(e);
	} finally {
		try { if (stmt != null) stmt.close(); } catch (Exception e) {};
		try { if (conn != null) conn.close(); } catch (Exception e) {};
	}
	
		
%>
