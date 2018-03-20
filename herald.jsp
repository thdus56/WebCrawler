<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements" %>
<html>
<head>
</head>
<body>
<%
	// 헤럴드경제 전체 기사 페이지
	Document doc = Jsoup.connect("http://biz.heraldcorp.com/list.php?ct=010000000000").get();
	
	// 페이지의 title 가져오기
	String title = doc.title();
	out.print(title + "<br><br>");
	
	// 기사 내용 부분 크롤링
	Elements links = doc.select("div.list ul li a");
	
	for (Element link : links) {
		// 기사 제목
		out.print(link.select("div.list_t1").text() + "<br>");
		// 기사 링크 주소
		out.print("http://biz.heraldcorp.com/"+link.attr("href")+"<br>");
		// 기사 작성일자
		out.print(link.select("div.list_t3").text() + "<br>");
	}

%>
</body>
</html>