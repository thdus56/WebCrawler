<%@ page contentType="application/json; charset=utf-8" language="java" %>
<%@ page import="java.util.*, java.text.*, org.jsoup.Jsoup, org.jsoup.nodes.Document, org.jsoup.nodes.Element, org.jsoup.select.Elements, org.json.*" %>
<%
	// 서울경제 전체뉴스 페이지
	Document doc = Jsoup.connect("http://www.sedaily.com/News/NewsAll").get();
	
	JSONArray array = new JSONArray();
	
	String title = "";
	String article_link = "";
	String write_date = "";
	
	// 시간 없어서 시간 임의 입력 (크롤링 시간으로)
	Date nowtime = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
	
	// 기사 크롤링할 태그 부분 선택
	Elements links = doc.select("ul.news_list li div");
	
	// 기사 내용 부분 크롤링
	for (Element link : links) {
		// 기사 제목
		title = link.select("dt a").text();
		// 기사 링크 주소
		article_link = "http://www.sedaily.com" + link.select("dt a").attr("href");
		// 기사 작성일자(날짜 뒤에 있는 시간 자름)
		write_date = link.select("dd span.letter").text() + " " + sdf.format(nowtime);
		
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