<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>성적 리스트</title>
<style>
	.container {
		display: flex;
		min-height: 100vh;
		font-family: 'Segoe UI', sans-serif;
		background-color: #f0f0f0;
	}
	
	.sidebar {
		width: 220px;
		background-color: #333;
		color: white;
		padding: 20px;
		box-sizing: border-box;
	}
	
	.main-content {
		margin-left: 230px;
		flex-grow: 1;
		padding: 30px;
		background-color: white;
	}
	
	button {
		margin-right: 10px;
		padding: 6px 12px;
	}
	
	table {
		width: 100%;
		border-collapse: collapse;
		margin-top: 20px;
		background-color: #fff;
	}
	
	th, td {
		border: 1px solid #ccc;
		padding: 10px;
		text-align: center;
	}
	
	th {
		background-color: #eee;
	}
</style>
</head>
<body>
<div class="container">
	<div class="sidebar">
		<jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
	</div>
	<div class="main-content">
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
	</div>
</div>
</body>
</html>