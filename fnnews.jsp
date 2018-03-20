<%@ page contentType="application/json; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements, org.json.*" %>
<%
	// 파이낸셜 뉴스 실시간 속보 페이지
	Document doc = Jsoup.connect("http://www.fnnews.com/newsflash/").get();
	
	// 기사 크롤링할 태그 부분 선택
	Elements links = doc.select("div.art_flash_wrap ul li");
	
	JSONArray array = new JSONArray();
	JSONObject jsonObj = new JSONObject();
	
	String title = "";
	String article_link = "";
	String write_date = "";
	
	// 반복문으로 기사 크롤링
	for (Element link : links) {
		
		// 기사 제목
		title = link.select("strong a").text().replaceAll("\"", "\'");
		// 기사 링크 주소
		article_link = "http://www.fnnews.com"+link.select("strong a").attr("href");
		// 기사 작성일자(뒤에 시간 자르고 .을 -로 바꿈)
		write_date = link.select("span.category_date").text().substring(0, 10).replaceAll("\\.", "-");
		
		JSONObject article = new JSONObject();
		article.put("title", title);
		article.put("article_link", article_link);
		article.put("write_date", write_date);
		
		//jsonarray에 jsonobject 하나씩 넣음
		array.put(article);
		
	}
	
	String all_news = array.toString();
	
%>
<%=all_news%>
