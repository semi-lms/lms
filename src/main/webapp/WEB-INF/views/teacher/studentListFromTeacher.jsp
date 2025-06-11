<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<h1>반 학생 리스트</h1>
	<table border="1">
		<tr>
			<th>이름</th>
			<th>생년월일</th>
			<th>성별</th>
			<th>메일</th>
			<th>전화번호</th>
		</tr>
		<c:forEach var="st" items="${students}">
			<tr>
				<td>${st.name}</td>
				<td>${st.birth}</td>
				<td>${st.gender}</td>
				<td>${st.email}</td>
				<td>${st.phone}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>