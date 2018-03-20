<%@ page contentType="application/json; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements" %>
<html>
<head>
</head>
<body>
<%
	// 충청일보 전체 뉴스 페이지
	Document doc = Jsoup.connect("http://www.ccdailynews.com/news/articleList.html?view_type=sm").get();
	
	// 페이지의 title 가져오기
	String title = doc.title();
	out.print(title + "<br><br>");
	
	// 기사 내용 부분 크롤링
	Elements links = doc.select("td.ArtList_Title");
	
	for (Element link : links) {
		// 기사 제목
		out.print(link.select("a").text() + "<br>");
		// 기사 링크 주소
		out.print("http://www.ccdailynews.com/news/"+link.select("a").attr("href")+"<br>");
		// 기사 작성일자
		out.print(link.select("div font.View_SmFont.FontEng").text() + "<br>");
	}

%>
</body>
</html>