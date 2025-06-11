<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<h1>성적 리스트</h1>
	<table border="1">
		<tr>
			<th>이름</th>
			<th>성적</th>
			<th>제출일</th>
		</tr>
		<c:forEach var="sc" items="${scores}">
			<tr>
				<td>${sc.name}</td>
				<td>${sc.score == null ? '미제출' : sc.score}</td>
				<td>${sc.submitDate == null ? '미제출' : sc.submitDate}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>