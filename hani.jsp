<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements, org.json.*" %>
<%
	// 한겨레 전체 기사 페이지
	Document doc = Jsoup.connect("http://www.hani.co.kr/arti/list.html").get();
	
	// 기사 내용 부분 크롤링
	Elements links = doc.select("div.article-area");
	
	JSONArray array = new JSONArray();
	JSONObject jsonObj = new JSONObject();
	
	String title = "";
	String article_link = "";
	String write_date = "";
	
	for (Element link : links) {
		// 기사 제목
		title = link.select(".article-title a").text();
		// 기사 링크 주소
		article_link = "http://www.hani.co.kr"+link.select(".article-title a").attr("href");
		// 기사 작성일자
		write_date = link.select("span.date").text();
		
		JSONObject article = new JSONObject();
		article.put("title", title);
		article.put("article_link", article_link);
		article.put("write_date", write_date);
		
		//jsonarray에 jsonobject 하나씩 넣음
		array.put(article);
	}
	
	String all_news = array.toString();
	
	out.print(all_news);

%>
