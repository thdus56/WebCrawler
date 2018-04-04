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
<body>
<%
	// post 방식으로 받은 파라미터를 utf-8로 인코딩
	request.setCharacterEncoding("UTF-8");
	
	// jdbc 드라이버 로드
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rset = null;
	
	// 클릭한 페이지
	String click_page = request.getParameter("page");
	String click_company = "";
	String search = "";
	
	// 언론사 선택
	if (request.getParameter("selectCompany") != null) {
		if (request.getParameter("selectCompany").equals("all")) {
			click_company = "";
		} else {
			click_company = request.getParameter("selectCompany");
		}
	}
	
	// 검색어 파라미터
	if (request.getParameter("search") != null) {
		search = request.getParameter("search");
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
	<form>
	<fieldset class="form-group">
		<legend class="col-form-label">언론사 선택</legend>
		<div class="form-check form-check-inline">
<%
			if (click_company.equals("") == true) {
				out.print("<input class='form-check-input' type='radio' name='selectCompany' id='all' value='all' checked>");
			} else {
				out.print("<input class='form-check-input' type='radio' name='selectCompany' id='all' value='all'>");
			}
%>	
			<label class="form-check-label" for="all">전체 선택</label>
		</div>
<%	
	String where_com = "";
	String where_search = "";
	String sql = "";
	String sql2 = "";
	
	// 언론사 카테고리 조건(where절에 붙일)
	if (click_company.equals("") == false) {
		where_com = "company = '"+click_company+"'";
	}
	
	// 검색어 조건(where절에 붙일)
	if (search.equals("") == false) {
		where_search = "title like '%"+search+"%'";
	}

	try {
		conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc14", "root", "911120");
		stmt = conn.createStatement();
		rset = stmt.executeQuery("select distinct company from TBL_ARTICLE;");
		
		String company = "";
		
		// 언론사 선택 라디오 버튼 출력
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
			} else if (rset.getString("company").equals("sedaily")) {
				company = "서울경제";
			} else if (rset.getString("company").equals("ytn")) {
				company = "YTN";
			}
			
			if (rset.getString("company").equals(click_company)) {
				out.print("<input class='form-check-input' type='radio' name='selectCompany' id='"+rset.getString("company")+"' value='"+rset.getString("company")+"' checked>"); 
			} else {
				out.print("<input class='form-check-input' type='radio' name='selectCompany' id='"+rset.getString("company")+"' value='"+rset.getString("company")+"'>"); 

			}
			out.print("<label class='form-check-label' for='"+rset.getString("company")+"'>"+company+"</label>");
			out.print("</div>");
		}
%>	
	<input type="submit" class="btn btn-primary btn-sm" value="선택">
	</fieldset>
	</form>
	<table class="table table-hover table-sm" style="table-layout:fixed;">
	<thead>
		<tr>
			<th scope="col" class="text-center" style="width: 20%;">언론사</th>
			<th scope="col" class="text-center" style="width: 60%;">기사 제목</th>
			<th scope="col" class="text-center" style="width: 20%;">날짜</th>
		</tr>
	</thead>
	<tbody>
<%	
		if (where_com.equals("") == false) {
			if (where_search.equals("") == false) {
				sql = "select count(*) from TBL_ARTICLE where " + where_com + " and " + where_search + " order by write_date desc;";
			} else {
				sql = "select count(*) from TBL_ARTICLE where " + where_com + " order by write_date desc;";
			}
		} else {
			if (where_search.equals("") == false) {
				sql = "select count(*) from TBL_ARTICLE where " + where_search + ";";
			} else {	
				sql = "select count(*) from TBL_ARTICLE order by write_date desc;";
			}
		}
		
		rset = stmt.executeQuery(sql);
		
		// 총 레코드 수 가져옴
		while(rset.next()) {
			totalCount = rset.getInt(1);
		}
		
		totalPage = totalCount / rows_per_page;				// 총 페이지 수 계산
		
		if (where_com.equals("") == false) {
			if (where_search.equals("") == false) {
				sql2 = "select * from TBL_ARTICLE where " + where_com + " and " + where_search + " order by write_date desc limit "+(startCount-1)+","+rows_per_page+";";
			} else {
				sql2 = "select * from TBL_ARTICLE where " + where_com + " order by write_date desc limit "+(startCount-1)+","+rows_per_page+";";
			}
		} else {
			if (where_search.equals("") == false) {
				sql2 = "select * from TBL_ARTICLE where " + where_search + " order by write_date desc limit "+(startCount-1)+","+rows_per_page+";";
			} else {
				sql2 = "select * from TBL_ARTICLE order by write_date desc limit "+(startCount-1)+","+rows_per_page+";";
			}	
		}
		
		rset = stmt.executeQuery(sql2);
		
		// 기사 출력 부분
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
			} else if (rset.getString("company").equals("sedaily")) {
				company = "서울경제";
			} else if (rset.getString("company").equals("ytn")) {
				company = "YTN";
			}
			
			out.print("<td class='text-center'>"+company+"</td>");
			out.print("<td style='text-overflow:ellipsis; overflow:hidden;'><nobr><a href='"+rset.getString("article_link")+"' target='_blank'>"+rset.getString("title")+"</nobr></a></td>");
			out.print("<td class='text-center'>"+rset.getString("write_date").substring(0, 10) +"</td>");
			out.print("<tr>");
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
	
	
	// 총 페이지 수 계산할 때 나머지가 있으면 +1
	if (totalCount % rows_per_page > 0) {
		totalPage++;
	}
	
	// 현재 페이지가 총 페이지보다 크면 강제로 총 페이지 수로 바꿈
	if (totalPage < curPage) {
		curPage = totalPage;
	}
	
	startPage = ((curPage - 1) / pageBlock) * pageBlock + 1;		// 블록 시작 페이지
	endPage = startPage + pageBlock - 1;							// 블록 끝 페이지
	
	// 블록 끝 페이지가 총 페이지 수보다 큰 경우 블록 끝페이지를 총 페이지로 바꿈
	if (endPage > totalPage) {
		endPage = totalPage;
	}

%>
	</tbody>
	</table>
	
	총 <%=totalCount%> 건 <br>

	<nav>
		<ul class="pagination pagination-sm justify-content-center">		
<%
		if (click_company.equals("") == false) {
			
			// 처음 버튼 표시(블록 시작 페이지가 1보다 클 경우)
			if (startPage > 1) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page=1&selectCompany="+click_company+"'>처음</a>");
				out.print("</li>");
			}
		
			// 이전 버튼 표시(현재 페이지가 1보다 크면 이전 버튼 활성화)
			if (curPage > 1) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page="+(curPage-1)+"&selectCompany="+click_company+"'>이전</a>");
				out.print("</li>");
			} else {
				out.print("<li class='page-item disabled'>");
				out.print("<a class='page-link' href='#' tabindex='-1'>이전</a>");
				out.print("</li>");
			}

			// 페이지 번호 출력
			for (int iCount = startPage; iCount <= endPage; iCount++) {
				if (iCount == curPage) {
					out.print("<li class='page-item active'><a class='page-link' href='?page="+iCount+"&selectCompany="+click_company+"'>"+iCount+"</a></li>");					
				} else {
					out.print("<li class='page-item'><a class='page-link' href='?page="+iCount+"&selectCompany="+click_company+"'>"+iCount+"</a></li>");
				}	
			}
			
			// 다음 버튼 표시(현재 페이지가 총 페이지보다 작을 때만 다음 버튼 활성화)
			if (curPage < totalPage) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page="+(curPage+1)+"&selectCompany="+click_company+"'>다음</a>");
				out.print("</li>"); 
			} else {
				out.print("<li class='page-item disabled'>");
				out.print("<a class='page-link' href='#' tabindex='-1'>다음</a>");
				out.print("</li>");
			}
			
			// 끝 버튼 표시(블록 끝페이지가 총 페이지보다 작을 때)
			if (endPage < totalPage) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page="+totalPage+"&selectCompany="+click_company+"'>끝</a>");
				out.print("</li>");
			}
		} else {
		
			// 처음 버튼 표시(블록 시작 페이지가 1보다 클 경우)
			if (startPage > 1) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page=1'>처음</a>");
				out.print("</li>");
			}
		
			// 이전 버튼 표시(현재 페이지가 1보다 크면 이전 버튼 활성화)
			if (curPage > 1) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page="+(curPage-1)+"'>이전</a>");
				out.print("</li>");
			} else {
				out.print("<li class='page-item disabled'>");
				out.print("<a class='page-link' href='#' tabindex='-1'>이전</a>");
				out.print("</li>");
			}

			// 페이지 번호 출력
			for (int iCount = startPage; iCount <= endPage; iCount++) {
				if (iCount == curPage) {
					out.print("<li class='page-item active'><a class='page-link' href='?page="+iCount+"'>"+iCount+"</a></li>");					
				} else {
					out.print("<li class='page-item'><a class='page-link' href='?page="+iCount+"'>"+iCount+"</a></li>");
				}	
			}
			
			// 다음 버튼 표시(현재 페이지가 총 페이지보다 작을 때만 다음 버튼 활성화)
			if (curPage < totalPage) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page="+(curPage+1)+"'>다음</a>");
				out.print("</li>"); 
			} else {
				out.print("<li class='page-item disabled'>");
				out.print("<a class='page-link' href='#' tabindex='-1'>다음</a>");
				out.print("</li>");
			}
			
			// 끝 버튼 표시(블록 끝페이지가 총 페이지보다 작을 때)
			if (endPage < totalPage) {
				out.print("<li class='page-item'>");
				out.print("<a class='page-link' href='?page="+totalPage+"'>끝</a>");
				out.print("</li>");
			}
		}					
%>
		</ul>
	</nav>
	
		<form method="post" class="needs-validation form-inline float-right" novalidate>
			<div class="form-row">
				<div class="col-auto">
					<input type="text" class="form-control form-control-sm" id="search" name="search" placeholder="제목 검색" required>
					<div class="invalid-feedback">
						검색어를 입력하세요!
					</div>
				</div>
				<div class="col-auto">
					<input type="submit" class="btn btn-primary btn-sm mb-2" value="검색">
				</div>	
			</div>
		</form>
		
	</div>
<script>
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('needs-validation');
    // Loop over them and prevent submission
    var validation = Array.prototype.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false);
    });
  }, false);
})();
</script>
</body>
</html>
