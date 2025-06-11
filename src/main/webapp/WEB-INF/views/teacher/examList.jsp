<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시험 리스트</title>
<script>
	function enterEditMode(examId) {
		document.getElementById("viewRow-" + examId).style.display = "none";
		document.getElementById("editRow-" + examId).style.display = "table-row";
	}
	
	function cancelEdit(examId) {
		document.getElementById("editRow-" + examId).style.display = "none";
		document.getElementById("viewRow-" + examId).style.display = "table-row";
	}
</script>
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
		<!-- 보기 모드 행 -->
		<tr id="viewRow-${exam.examId}">
			<td>${exam.title}</td>
			<td>${exam.status}</td>
			<td>${exam.examStartDate}</td>
			<td>${exam.examEndDate}</td>
			<td>
				<c:if test="${exam.status eq '예정'}">
					<button type="button" onclick="enterEditMode(${exam.examId})">수정</button>
				</c:if>
			</td>
			<td>
				<c:if test="${exam.status eq '예정'}">
					<button type="button" onclick="deleteExam(${exam.examId})">삭제</button>
				</c:if>
			</td>
		</tr>

		<!-- 수정 모드 행 -->
		<tr id="editRow-${exam.examId}" style="display:none;">
			<form method="post" action="/updateExam">
				<td><input type="text" name="title" value="${exam.title}" /></td>
				<td>${exam.status}</td>
				<td><input type="date" name="examStartDate" value="${exam.examStartDate}" /></td>
				<td><input type="date" name="examEndDate" value="${exam.examEndDate}" /></td>
				<td>
					<input type="hidden" name="examId" value="${exam.examId}" />
					<button type="submit">저장</button>
					<button type="button" onclick="cancelEdit(${exam.examId})">취소</button>
				</td>
				<td></td>
			</form>
		</tr>
	</c:forEach>
</table>
</body>
</html>
