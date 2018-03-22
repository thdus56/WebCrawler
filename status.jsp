<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="UTF-8">
 
 <title>JSP JSON TESTPage</title>

 <!-- Ajax 사용을 위한 jquery -->
 <script src="http://code.jquery.com/jquery-1.12.4.min.js"></script>
 <!-- JavaScript -->
 <script type="text/javascript">
  $(document).ready(function() {
	$("#button").click(function() {
		crawlingNews("fnnews");
		crawlingNews("hani");
		crawlingNews("hankyung");
		crawlingNews("ccdailynews");
		crawlingNews("herald");
	});
  });

  function crawlingNews(company) {
	$.ajax({
		url: "" + company + ".jsp",		// 클라이언트가 요청을 보낼 서버의 URL주소(데이터를 받아올 곳)
		type: "post",					// HTTP 요청 방식(GET, POST)
		dataType: "json",				// 서버에서 보내줄 데이터 타입
	}).done(function(resdata) {
		document.getElementById("status_"+company).innerHTML = "기사 수집 성공";
		moveToInsertDB(company, resdata);
	}).fail(function(xhr, status, errorThrown) {
		document.getElementById("status+_"+company).innerHTML = "기사 수집 오류: " + errorThrown;
	});
  }
 
  function moveToInsertDB(company, resdata) {
	$.ajax({
		url: "insertDB.jsp",
		type: "post",
		dataType: "text",
		data: {
			company: company,
			articleArray: JSON.stringify(resdata),
			status: "success",
		}											// HTTP 요청과 함께 서버로 보낼 데이터
	}).done(function() {
		document.getElementById("status_"+company).innerHTML = "DB 입력 성공";
	}).fail(function(xhr, status, errorThrown) {
		document.getElementById("status_"+company).innerHTML = "DB 입력 오류: " + errorThrown;
	});
  }
 </script>
</head>
<body>
<center>언론사 크롤링 상태</center>
<form id="status_form">
<input type="button" id="button" value="크롤링 시작">
<table border=1 width=100%>
	<tr>
		<td>언론사</td>
		<td>크롤링 상태</td>
	</tr>
	<tr>
		<td>파이낸셜뉴스</td>
		<td id="status_fnnews"></td>
	</tr>
	<tr>
		<td>한겨레</td>
		<td id="status_hani"></td>
	</tr>
	<tr>
		<td>한국경제</td>
		<td id="status_hankyung"></td>
	</tr>
	<tr>
		<td>충청일보</td>
		<td id="status_ccdailynews"></td>
	</tr>
	<tr>
		<td>헤럴드경제</td>
		<td id="status_herald"></td>
	</tr>
</table>
</form>
</body>
</html>