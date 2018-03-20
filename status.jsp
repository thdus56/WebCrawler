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
	});
  });

  function crawlingNews(company) {
	$.ajax({
		url: "" + company + ".jsp",		// 클라이언트가 요청을 보낼 서버의 URL주소(데이터를 받아올 곳)
		type: "post",					// HTTP 요청 방식(GET, POST)
		dataType: "json",				// 서버에서 보내줄 데이터 타입
		success: function(resdata) {
			document.getElementById(company).innerHTML = "기사 수집 성공";
			moveToInsertDB(company, resdata);
		},
		error: function() {
			document.getElementById(company).innerHTML = "기사 수집 에러";
		}
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
			status: "success"
		},
		success: function(restext){
			alert(restext);
			document.getElementById(company).innerHTML = "DB 성공";
			
		},
		error: function(resdata) {
			alert(resdata);
			document.getElementById(company).innerHTML = "DB 오류";
		}
	});
		
	
  }
 </script>
</head>
<body>
<form id="status_form">
<input type="button" id="button" value="크롤링 시작">
<table border=1>
	<tr>
		<td>언론사</td>
		<td>크롤링 상태</td>
	</tr>
	<tr>
		<td>파이낸셜뉴스</td>
		<td id="fnnews"></td>
	</tr>
	<tr>
		<td>한겨레</td>
		<td id="hani"></td>
	</tr>
	<tr>
		<td>한국경제</td>
		<td id="hankyung"></td>
	</tr>
	<tr>
		<td>충청일보</td>
		<td id="ccdailynews"></td>
	</tr>
	<tr>
		<td>헤럴드경제</td>
		<td id="herald"></td>
	</tr>
</table>
</form>
</body>
</html>