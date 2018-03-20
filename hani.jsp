<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements" %>
<html>
<head>
</head>
<body>
<%
	// 한겨레 전체 기사 페이지
	Document doc = Jsoup.connect("http://www.hani.co.kr/arti/list.html").get();
	
	// 페이지의 title 가져오기
	String title = doc.title();
	out.print(title + "<br><br>");
	
	// 기사 내용 부분 크롤링
	Elements links = doc.select("div.article-area");
	
	for (Element link : links) {
		// 기사 제목
		out.print(link.select(".article-title a").text() + "<br>");
		// 기사 링크 주소
		out.print("http://www.hani.co.kr"+link.select(".article-title a").attr("href")+"<br>");
		// 기사 작성일자
		out.print(link.select("span.date").text() + "<br>");
	}

%>
</body>
</html>