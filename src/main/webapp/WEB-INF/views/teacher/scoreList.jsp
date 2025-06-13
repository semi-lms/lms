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
		<form method="get" action="/scoreList">
			<input type="hidden" name="examId" value="${examId}" />
			<input type="hidden" name="courseId" value="${courseId}" />
			<input type="hidden" name="currentPage" value="${currentPage}" />
			<button type="submit" name="filter" value="전체" ${filter == '전체' ? 'disabled' : ''}>전체</button>
			<button type="submit" name="filter" value="미제출" ${filter == '미제출' ? 'disabled' : ''}>미제출</button>
			<button type="submit" name="filter" value="제출" ${filter == '제출' ? 'disabled' : ''}>제출</button>
		</form>
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
		<c:if test="${lastPage > 1 }">
			<c:if test="${startPage > 1 }">
				<a href="/teacher/scoreList?currentPage=${startPage - 1}&rowPerPage=${rowPerPage}&filter=${filter}">[이전]</a>
			</c:if>
		</c:if>
		<c:forEach var="i" begin="${startPage}" end="${endPage}">
			<c:choose>
				<c:when test="${i == currentPage }">
					<span>[${i}]</span>
				</c:when>
				<c:otherwise>
					<a href="/teacher/scoreList?currentPage=${i}&rowPerPage=${rowPerPage}&filter=${filter}">[${i}]</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:if test="${endPage < lastPage }">
			<a href="/teacher/scoreList?currentPage=${endPage+1}&rowPerPage=${rowPerPage}&filter=${filter}">[다음]</a>
		</c:if>
	</div>
</div>
</body>
</html>