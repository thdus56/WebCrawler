<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>

<%
	String aa = "";
	String number = request.getParameter("number");
 
	if (number.equals("1")) {
		aa = "[{\"term\": \"haha. 하하\", \"part\": \"형용사\", \"definition\" : \"웃음소리\"}]";
	}
%>

<%=aa%>
