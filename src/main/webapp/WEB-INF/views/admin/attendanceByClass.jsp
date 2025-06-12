<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<h1>hello</h1>
	<table border="1">
		<tr>
			<td>1</td>
			<td>2</td>
			<td>3</td>
		</tr>
		
		<c:forEach var="item" items="${attendanceList}">
		  <tr>
		    <td>${item.classroom}</td>
		    <td>${item.name}</td>
		    <td>${item.attendanceCount}</td>
		  </tr>
		</c:forEach>
	</table>
</body>
</html>