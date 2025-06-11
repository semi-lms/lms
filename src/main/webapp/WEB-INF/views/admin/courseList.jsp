<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<h1>강의 목록</h1>
	<form method="get">
		<table border="1">
			<tr>
				<th>담당 강사</th>
				<th>강의명</th>
				<th>기간</th>
				<th>강의실</th>
				<th>수강 인원</th>
			</tr>
			<c:forEach var="course" items="${courseList}">
				<tr>
					<td>${course.teacherName}</td>
					<td>${course.courseName}</td>
					<td>${course.startDate}</td>
					<td><a href="attendance"> ${course.classroom } </a></td>
					<td>${course.applyPerson }</td>
				</tr>
			</c:forEach>
		</table>
		<button type="button" id="insertCourse">강의 등록</button>
		<br> <select name="searchCourseOption" id="searchCourseOption">
			<option value="all" ${searchCourseOption == 'all' ? 'selected' : ''}>전체</option>
			<option value="teacherName"
				${searchCourseOption == 'teacherName' ? 'selected' : ''}>강사</option>
			<option value="courseName"
				${searchCourseOption == 'courseName' ? 'selected' : ''}>강의명</option>
		</select> <input type="text" name="searchCourse" id="searchCourse"
			value="${searchCourse}" placeholder="검색">
		<button type="submit" id="searchBtn">검색</button>
	</form>

	<c:if test="${page.lastPage > 1 }">
		<c:if test="${startPage > 1 }">
			<a
				href="/admin/courseList?currentPage=${startPage - 1}&rowPerPage=${page.rowPerPage}&searchCourseOption=${searchCourseOption}&searchCourse=${searchCourse}">[이전]</a>
		</c:if>
	</c:if>
	<c:forEach var="i" begin="${startPage}" end="${endPage}">
		<c:choose>
			<c:when test="${i == page.currentPage }">
				<span>[${i}]</span>
			</c:when>
			<c:otherwise>
				<a
					href="/admin/courseList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchCourseOption=${searchCourseOption}&searchCourse=${searchCourse}">[${i}]</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:if test="${endPage < page.lastPage }">
		<a
			href="/admin/courseList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchCourseOption=${searchCourseOption}&searchCourse=${searchCourse}">[다음]</a>
	</c:if>

	<script>
		$("#insertCourse").click(function(){
		    window.location = "insertCourse";
		});
	</script>
</body>
</html>