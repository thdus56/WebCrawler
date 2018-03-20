<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements" %>
<html>
<head>
</head>
<body>
<%
	// 파이낸셜 뉴스 실시간 속보 페이지
	Document doc = Jsoup.connect("http://www.fnnews.com/newsflash/").get();
	
	// 페이지의 title 가져오기
	String title = doc.title();
	out.print(title + "<br><br>");
	
	// 기사 내용 부분 크롤링
	Elements links = doc.select("div.art_flash_wrap ul li");
	
	for (Element link : links) {
		// 기사 제목
		out.print(link.select("strong a").text() + "<br>");
		// 기사 링크 주소
		out.print("http://www.fnnews.com"+link.select("strong a").attr("href")+"<br>");
		// 기사 작성일자
		out.print(link.select("span.category_date").text() + "<br>");
	}

%>
</body>
</html>