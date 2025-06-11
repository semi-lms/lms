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
	<h1>강의 목록</h1>
	<form method="post">
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
				<td>
					<a href="attendance">
						${course.classroom }
					</a>	
				</td>
				<td>${course.maxPerson }</td>
			</tr>
		</c:forEach>
	</table>
		<button type="button" id="insertCourse">강의 등록</button>
		<br>
		<select id="searchCourseOption">
			<option id="all">전체</option>
			<option id="teacher">강사</option>
			<option id="courseName">강의명</option>
		</select>
		<input type="text" name="searchCourse" id="searchCourse" placeholder="검색">
		<button type="submit" id="searchBtn">검색</button>
	</form>
	<script>
		$("#insertCourse").click(function(){
		    window.location = "insertCourse";
		});
	</script>
</body>
</html>