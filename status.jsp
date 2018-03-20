<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
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
		callAjax();
	});
  });

  function callAjax() {
	$.ajax({
		url: "a.jsp",			// 클라이언트가 요청을 보낼 서버의 URL주소(데이터를 받아올 곳)
		type: "post",			// HTTP 요청 방식(GET, POST)
		dataType: "json",		// 서버에서 보내줄 데이터 타입
		data: {
			number : $('#number').val()
		},						// HTTP 요청과 함께 서버로 보낼 데이터
		success: whenSuccess,
		error: whenError
	});
  }
 
  
  function whenSuccess(resdata) {
	var html = "<table border=1 width=500>";
	
	$.each(resdata, function(entryIndex, entry) {
		html += "<tr>";
		html += "<td>" + entry.term + "</td>";
		html += "<td width=50>" + entry.part + "</td>";
		html += "<td>" + entry.definition + "</td>";
		if (entry.quote != null) {
			html += "<td>" + entry.quote[0] + "</td>";
		} else {
			html += "<td>" + "없음" + "</td>";
		}
		
		html += "</tr>";
	});
	html += "</table>";
	$(".ajaxReturn").html(html);
	//console.log(resdata);
	//alert(resdata);
  }
  
  function whenError() {
	alert("Error");
  }
 </script>
 </head>
 <body>
 <table>
 <form id="frm">
	<tr>
		<td>글번호</td>
		<td><input name="number" id="number"></td>
	</tr>
	<tr>
		<td colspan=2><input type="button" id="button" value="버튼"></td>
	</tr>
 </form>
 </table>
 <div class="ajaxReturn"> </div>
 </body>
 </html>