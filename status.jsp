<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>크롤링 서버 페이지</title>
<!-- Ajax 사용을 위한 jquery -->
<script src="http://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- bootstrap CSS-->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<!-- JavaScript -->
<script type="text/javascript">
$(document).ready(function() {
	setInterval("dpTime()", 1000);
	
	crawlingNews("fnnews");
	crawlingNews("hani");
	crawlingNews("hankyung");
	crawlingNews("ccdailynews");
	crawlingNews("sedaily");
	crawlingNews("ytn");
	// 300초(5분)마다 페이지 새로고침(300*1000)
	setTimeout("location.reload()", 300000);
});

// 크롤링 시작 시간 측정
function crawling_start(company) {
	var startTime = new Date().getTime();
	return startTime;
}

// 크롤링 종료 시간 측정
function crawling_end(company) {
	var endTime = new Date().getTime();
	return endTime;
}

// 크롤링 소요시간 계산식
function countTime(company, start, end) {
	document.getElementById("time_" + company).innerHTML = (end - start) / 1000 + "초";
}

function crawlingNews(company) {
	var startTime = crawling_start(company);
	
	countBeforeAll(company);
	
	$.ajax({
		url: "" + company + ".jsp",		// 클라이언트가 요청을 보낼 서버의 URL주소(데이터를 받아올 곳)
		type: "post",					// HTTP 요청 방식(GET, POST)
		dataType: "json",				// 서버에서 보내줄 데이터 타입
	}).done(function(resdata) {
		document.getElementById("status_"+company).innerHTML = "기사 수집 성공";
		document.getElementById("status_"+company).classList.toggle('table-warning');
		moveToInsertDB(company, resdata);
		checkDupl(company, resdata);
		countTime(company, startTime, crawling_end(company));
	}).fail(function(xhr, status, errorThrown) {
		document.getElementById("status_"+company).innerHTML = "기사 수집 오류: " + errorThrown;
		document.getElementById("status_"+company).classList.toggle('table-danger');
		countTime(company, startTime, crawling_end(company));
	});

}

function moveToInsertDB(company, resdata) {
	$.ajax({
		url: "insertDB.jsp",
		type: "post",
		dataType: "json",
		data: {
			company: company,
			articleArray: JSON.stringify(resdata),
			status: "success",
		}											// HTTP 요청과 함께 서버로 보낼 데이터
	}).done(function(data) {
		document.getElementById("status_"+company).classList.remove('table-warning');
		document.getElementById("status_"+company).innerHTML = "DB 입력 성공";
		document.getElementById("status_"+company).classList.toggle('table-success');
	}).fail(function(xhr, status, errorThrown) {
		document.getElementById("status_"+company).innerHTML = "DB 입력 오류: " + errorThrown;
		document.getElementById("status_"+company).classList.toggle('table-danger');
		
	});
}

// 크롤링한 기사 중에 중복 체크
function checkDupl(company, resdata) {
	$.ajax({
		url: "checkDB.jsp",				// 클라이언트가 요청을 보낼 서버의 URL주소(데이터를 받아올 곳)
		type: "post",					// HTTP 요청 방식(GET, POST)
		dataType: "json",				// 서버에서 보내줄 데이터 타입
		data: {
			company: company,
			articleArray: JSON.stringify(resdata),
		}
	}).done(function(data) {
		document.getElementById("old_"+company).innerHTML = data.dup_cnt;
		document.getElementById("new_"+company).innerHTML = data.new_cnt;
	}).fail(function(xhr, status, errorThrown) {
		document.getElementById("old_"+company).innerHTML = "중복 체크 오류: " + errorThrown;
		document.getElementById("new_"+company).innerHTML = "중복 체크 오류: " + errorThrown;
	});
}

// 크롤링하기 전 기사 개수 카운트
function countBeforeAll(company) {
	$.ajax({
			url: "table.jsp",
			type: "post",
			data: { 
				company: company,
			}
	}).done(function(data) {
		document.getElementById("total_"+company).innerHTML = data;
	}).fail(function(xhr, status, errorThrown) {
		document.getElementById("total_"+company).innerHTML = "기사 카운트 에러: " + errorThrown;
	});
}

// 시계 출력
function dpTime() {
	var now = new Date();
	var hours = now.getHours();
	var minutes = now.getMinutes();
	var seconds = now.getSeconds();
	
	if (hours > 12) {
		hours = hours - 12;
		ampm = "오후";
	} else {
		ampm = "오전";
	}
	
	if (hours < 10) {
		hours = "0" + hours;
	}
	
	if (minutes < 10) {
		minutes = "0" + minutes;
	}
	
	if (seconds < 10) {
		seconds = "0" + seconds;
	}
	
	var nowTime = now.getFullYear() + "년 " + (now.getMonth()+1) + "월 " + now.getDate() + "일 " + ampm + " " + hours + ":" + minutes + ":" + seconds;
	
	document.getElementById("dpTime").innerHTML = nowTime; 
}
 
</script>
</head>
<body>
<br>

<div class="container">
<h4><p id="dpTime" class="text-right font-weight-light"></p></h4>
<br><h3><p class="text-center">언론사 크롤링 상태</p></h3><br>
<form id="status_form">
<!--<input type="button" id="button" value="크롤링 시작">-->
<table class="table table-bordered text-center">
	<thead class="thead-light">
		<tr>
			<th scope="col">언론사</th>
			<th scope="col">크롤링 상태</th>
			<th scope="col">소요 시간</th>
			<th scope="col">크롤링 전 기사 개수</th>
			<th scope="col">신규 기사</th>
			<th scope="col">중복 기사</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>파이낸셜뉴스</td>
			<td id="status_fnnews"></td>
			<td id="time_fnnews"></td>
			<td id="total_fnnews"></td>
			<td id="new_fnnews"></td>
			<td id="old_fnnews"></td>
		</tr>
		<tr>
			<td>한겨레</td>
			<td id="status_hani"></td>
			<td id="time_hani"></td>
			<td id="total_hani"></td>
			<td id="new_hani"></td>
			<td id="old_hani"></td>
		</tr>
		<tr>
			<td>한국경제</td>
			<td id="status_hankyung"></td>
			<td id="time_hankyung"></td>
			<td id="total_hankyung"></td>
			<td id="new_hankyung"></td>
			<td id="old_hankyung"></td>
		</tr>
		<tr>
			<td>충청일보</td>
			<td id="status_ccdailynews"></td>
			<td id="time_ccdailynews"></td>
			<td id="total_ccdailynews"></td>
			<td id="new_ccdailynews"></td>
			<td id="old_ccdailynews"></td>
		</tr>
		<tr>
			<td>서울경제</td>
			<td id="status_sedaily"></td>
			<td id="time_sedaily"></td>
			<td id="total_sedaily"></td>
			<td id="new_sedaily"></td>
			<td id="old_sedaily"></td>
		</tr>
		<tr>
			<td>YTN</td>
			<td id="status_ytn"></td>
			<td id="time_ytn"></td>
			<td id="total_ytn"></td>
			<td id="new_ytn"></td>
			<td id="old_ytn"></td>
		</tr>
	</tbody>
</table>
</form>
</div>
</body>
</html>