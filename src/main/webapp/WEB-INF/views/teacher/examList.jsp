<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<h1>시험 리스트</h1>
	<table border="1">
		<tr>
			<th>제목</th>
			<th>진행도</th>
			<th>시작일</th>
			<th>종료일</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<c:forEach var="exam" items="${exams}">
			<tr>
				<td>${exam.title}</td>
				<td>${exam.status}</td>
				<td>${exam.examStartDate}</td>
				<td>${exam.examEndDate}</td>
				<td><a href="">수정</a></td>
				<td><a href="">삭제</a></td>
			</tr>		
		</c:forEach>
	</table>
</body>
</html>