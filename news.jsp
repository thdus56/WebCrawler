<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<!-- Ajax 사용을 위한 jquery -->
<script src="http://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- bootstrap CSS-->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script type="text/javascript">
$(document).ready(function() {
	//checkedValue();
	
	$("input:radio[name='selectCompany']").change(function() {
		var now = this.value;
		alert(now);
	});
	
	$(".btn-danger").click(function() {
		var click = $(".form-check-input:checked").val();
		//checkedValue();
	
		$.ajax({
			type: "post",
			url: "table.jsp",
			data: { 
				company: "hani",
			},
			success: function(data) {
				if (data == "hani") {
					$("#test").html("테스트");
				}
				$("#result").html(data);
			}
			
		});
		
	});
	
});

function checkedValue() {
	var checked = $(".form-check-input:checked").val();
	alert(checked);
}

</script>
</head>
<body>
<%
	// jdbc 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rset = null;
	
	// 클릭한 페이지
	String click_page = request.getParameter("page");
	String click_company = "";
	
	// 언론사 선택
	if (request.getParameter("selectCompany") != null) {
		click_company = request.getParameter("selectCompany");
	}
	
	
	int curPage = 1;									// 현재 페이지
	int totalCount = 0;									// 총 레코드 수
	int rows_per_page = 20;								// 한 페이지에 출력할 레코드 개수
	int totalPage = 0;									// 총 페이지 수
	int pageBlock = 10;									// 한 화면에 출력할 페이지 개수
	int startPage = 1;									// 블록 시작 페이지
	int endPage = 10;									// 블록 끝 페이지
	
	// 클릭한 페이지를 현재 페이지로 설정
	if (click_page != null) {
		curPage = Integer.parseInt(click_page);
	} else {
		curPage = 1;
	}
	
	// 게시물 시작 번호, 끝 번호
	int startCount = (curPage - 1) * rows_per_page + 1;
	int endCount = curPage * rows_per_page;
	
%>
	<div class="container">
	<br><h3><center>기사 목록</center></h3><br>
	
	<fieldset class="form-group">
		<legend class="col-form-label">언론사 선택</legend>
		<div class="form-check form-check-inline">
			<input class="form-check-input" type="radio" name="selectCompany" id="all" value="all" checked> 
			<label class="form-check-label" for="all">전체 선택</label>
		</div>
<%	
	String where_com = "";
	String sql = "";
	String sql2 = "";
	
	if (click_company.equals("") == false) {
		where_com = "company = '"+click_company+"'";
	}

	try {
		conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc14", "root", "911120");
		stmt = conn.createStatement();
		rset = stmt.executeQuery("select distinct company from TBL_ARTICLE;");
		
		String company = "";
		
		while(rset.next()) {
			out.print("<div class='form-check form-check-inline'>");
			
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
			} else if (rset.getString("company").equals("ytn")) {
				company = "YTN";
			}
			
			out.print("<input class='form-check-input' type='radio' name='selectCompany' id='"+rset.getString("company")+"' value='"+rset.getString("company")+"'>"); 
			out.print("<label class='form-check-label' for='"+rset.getString("company")+"'>"+company+"</label>");
			
			out.print("</div>");
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
	<input type="submit" class="btn btn-primary" value="검색">
	</fieldset>
	
	<button type="button" class="btn btn-danger">호출</button>
	
	<div id="result">
	</div>
	<div id="test">
	</div>

</body>
</html>
