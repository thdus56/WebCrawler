<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, org.json.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%
	
	// jdbc 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	
	String status = request.getParameter("status");
	String company = request.getParameter("company");
	String articleArray = request.getParameter("articleArray");
	
	String title = "";
	String article_link = "";
	String write_date = "";
	
	int insert_cnt = 0;
	
	// status.jsp에서 넘어온 배열값을 jsonarray로 받음
	JSONArray array = new JSONArray(articleArray);
	
	try {
		// Connection 객체 생성
		conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc14", "root", "911120");
		// Statement 객체 생성
		stmt = conn.createStatement();
		
		for (int i = 0; i < array.length(); i++) {
			// jsonarray를 하나씩 jsonobject로 받음
			JSONObject oneNews = array.getJSONObject(i);
			
			// 작은 따옴표 치환(DB 입력할 때 오류 안 나게)
			title = oneNews.getString("title").replaceAll("'", "&#39;");
			article_link = oneNews.getString("article_link");
			write_date = oneNews.getString("write_date");
			
			// PK가 중복이면 무시하고 insert
			stmt.execute("insert ignore TBL_ARTICLE(company, title, article_link, write_date)"
						+"values ('"+company+"', '"+title+"', '"+article_link+"', '" + write_date +"');");
		
			insert_cnt++;
		}
	} catch (SQLException e) {
		status = e.toString();
		out.print(e);
	} catch (Exception e) {
		status = e.toString();
		out.print(e);
	} finally {
		try { if (stmt != null) stmt.close(); } catch (Exception e) {};
		try { if (conn != null) conn.close(); } catch (Exception e) {};
	}
		
%>
<%
	JSONObject count_obj = new JSONObject();
	
	count_obj.put("insertcnt", insert_cnt);
	count_obj.put("length", array.length());

	out.print(count_obj.toString());
	
%>
