<%@ page contentType="application/json; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements, org.json.*" %>
<%
	// YTN 최신뉴스 페이지
	Document doc = Jsoup.connect("http://www.ytn.co.kr/news/news_quick.html").get();
	
	JSONArray array = new JSONArray();
	
	String title = "";
	String article_link = "";
	String write_date = "";
	
	// 기사 크롤링할 태그 부분 선택
	Elements links = doc.select("dl.news_list_v2014");
	
	// 반복문으로 기사 크롤링
	for (Element link : links) {
		
		// 기사 제목
		title = link.select("dt a").text().replaceAll("\"", "\'");
		// 기사 링크 주소
		article_link = "http://www.ytn.co.kr" + link.select("dt a").attr("href");
		// 기사 작성일자(날짜 뒤에 있는 시간 자르고 .을 -로 바꿈)
	write_date = link.select("dd.date").text().replaceAll("\\[", "").replaceAll("\\]", "") + ":00";
		
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

