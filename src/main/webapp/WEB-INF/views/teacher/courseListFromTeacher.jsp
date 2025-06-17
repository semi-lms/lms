<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강사-강의리스트</title>
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
		<h1>강의 리스트</h1>
		<form method="get" action="/courseListFromTeacher">
			<input type="hidden" name="teacherNo" value="${teacherNo}" />
			<input type="hidden" name="currentPage" value="${currentPage}" />
			<button type="submit" name="filter" value="전체" ${filter == '전체' ? 'disabled' : ''}>전체</button>
			<button type="submit" name="filter" value="예정" ${filter == '예정' ? 'disabled' : ''}>예정</button>
			<button type="submit" name="filter" value="진행중" ${filter == '진행중' ? 'disabled' : ''}>진행중</button>
			<button type="submit" name="filter" value="완료" ${filter == '완료' ? 'disabled' : ''}>완료</button>
		</form>
	
		<table border="1">
			<tr>
				<th>과정명</th>
				<th>시작일</th>
				<th>종료일</th>
				<th>진행상태</th>
			</tr>
			<c:forEach var="course" items="${courses}">
				<tr>
					<td><a href="/attendanceList?courseId=${course.courseId}">${course.courseName}</a></td>
					<td>${course.startDate}</td>
					<td>${course.endDate}</td>
					<td>${course.courseActive}</td>
				</tr>
			</c:forEach>
		</table>
		<c:forEach var="i" begin="1" end="${lastPage}">
			<c:choose>
				<c:when test="${i == currentPage }">
					<span>[${i}]</span>
				</c:when>
				<c:otherwise>
					<a href="/courseListFromTeacher?teacherNo=${teacherNo}&currentPage=${i}&filter=${filter}">[${i}]</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</div>
</div>
</body>
</html>