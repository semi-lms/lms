<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강사-강의리스트</title>
</head>
<body>
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
				<td>${course.courseName}</td>
				<td>${course.startDate}</td>
				<td>${course.endDate}</td>
				<td>${course.courseActive}</td>
			</tr>
		</c:forEach>
	</table>
	<c:if test="${lastPage > 1 }">
		<c:if test="${startPage > 1 }">
			<a href="/teacher/courseListFromTeacher?currentPage=${startPage - 1}&rowPerPage=${rowPerPage}&filter=${filter}">[이전]</a>
		</c:if>
	</c:if>
	<c:forEach var="i" begin="${startPage}" end="${endPage}">
		<c:choose>
			<c:when test="${i == currentPage }">
				<span>[${i}]</span>
			</c:when>
			<c:otherwise>
				<a href="/teacher/courseListFromTeacher?currentPage=${i}&rowPerPage=${rowPerPage}&filter=${filter}">[${i}]</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:if test="${endPage < lastPage }">
		<a href="/teacher/courseListFromTeacher?currentPage=${endPage+1}&rowPerPage=${rowPerPage}&filter=${filter}">[다음]</a>
	</c:if>
</body>
</html>