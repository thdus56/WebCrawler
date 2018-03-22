<%@ page contentType="application/json; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements, org.json.*" %>
<%
	// 충청일보 전체 뉴스 페이지
	Document doc = Jsoup.connect("http://www.ccdailynews.com/news/articleList.html?view_type=sm").get();
	
	JSONArray array = new JSONArray();
	
	String title = "";
	String article_link = "";
	String write_date = "";
	
	// 기사 크롤링할 태그 부분 선택
	Elements links = doc.select("td.ArtList_Title");
	
	// 기사 내용 부분 크롤링
	for (Element link : links) {
		// 기사 제목
		title = link.select("a").text();
		// 기사 링크 주소
		article_link = "http://www.ccdailynews.com/news/"+link.select("a").attr("href");
		// 기사 작성일자
		write_date = link.select("div font.View_SmFont.FontEng").text();
		
		JSONObject article = new JSONObject();
		article.put("title", title);
		article.put("article_link", article_link);
		article.put("write_date", write_date);
		
		// jsonarray에 jsonobject 하나씩 넣음
		array.put(article);
	}

	String all_news = array.toString();
	
	out.print(all_news);
	
%>
