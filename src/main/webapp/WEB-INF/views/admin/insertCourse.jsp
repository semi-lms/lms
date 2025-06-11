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
						<option>강 사 선 택</option>
						<option>등록된 강사중 고르셈</option>
						<option id="teacherName">노민혁</option>
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
			        <select name="classroom" required>
			            <option value="">강의실 선택</option>
			            <option value="C반">A반</option>
			            <option value="C반">B반</option>
			            <option value="C반">C반</option>
			            <option value="D반">D반</option>
			            <option value="D반">E반</option>
			        </select>
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