<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, org.json.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%
	
	// jdbc 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rset = null;
	
	String status = request.getParameter("status");
	String company = request.getParameter("company");
	String articleArray = request.getParameter("articleArray");
	
	String title = "";
	String new_link = "";
	String write_date = "";
	
	int dup_cnt = 0;
	
	// status.jsp에서 넘어온 배열값을 jsonarray로 받음
	JSONArray array = new JSONArray(articleArray);
	
	try {
		// Connection 객체 생성
		conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc14", "root", "911120");
		// Statement 객체 생성
		stmt = conn.createStatement();
		// 기사 링크 조회
		rset = stmt.executeQuery("select article_link from TBL_ARTICLE where company = '"+company+"';");
		
		// DB에서 조회한 링크를 크롤링한 링크와 비교
		while (rset.next()) {
			
			for (int i = 0; i < array.length(); i++) {
				// jsonarray를 하나씩 jsonobject로 받음
				JSONObject oneNews = array.getJSONObject(i);
				new_link = oneNews.getString("article_link");
				
				// 링크가 같으면 카운트 증가(중복 +)
				if (new_link.equals(rset.getString("article_link")) == true) {
					dup_cnt++;
				}
			}
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
	
	count_obj.put("dup_cnt", dup_cnt);
	count_obj.put("length", array.length());
	count_obj.put("new_cnt", array.length() - dup_cnt);

	out.print(count_obj.toString());
	
%>
