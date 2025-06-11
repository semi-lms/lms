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
	<h1>강의 등록</h1>
	<form action="insertCourse" method="post">
		<table border="1">
			<tr>
				<th>담당 강사</th>
				<td>
					<select>
						<c:forEach var="teacher" items="${teacher}">
							<option value=${teacher}>${teacher.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>강의명</th>
				<td>
					<input type="text" name="courseName" id="courseName">
				</td>
			</tr>
			<tr>
				<th>강의 설명</th>
				<td>
					<input type="text" name="description" id="description">
				</td>
			</tr>
			<tr>
				<th>시작일</th>
				<td><input type="date" name="startDate" id="startDate"></td>
			</tr>
			<tr>
				<th>종료일</th>
				<td><input type="date" name="endDate" id="endDate"></td>
			</tr>
			<tr>
				<th>강의실</th>
				<td>
					<c:forEach var="class" items="${class}">
						<option value=${class}>${class.classroom}</option>
					</c:forEach>
				</td>
			</tr>
			<tr>
				<th>수강정원</th>
				<td><input type="text" readonly></td>
			</tr>
		</table>
		<button type="submit">강의 등록</button>
	</form>
</body>
</html>