<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문제 리스트</title>
<style>
	.card-container {
		display: grid;
		grid-template-columns: repeat(2, 1fr); /* 2열 */
		gap: 2px;
		max-width: 960px;
		margin: 0 auto;
		padding: 20px;
	}
	
	.card {
		background-color: #fff;
		border: 1px solid #ddd;
		border-radius: 12px;
		padding: 16px;
		box-shadow: 0 2px 6px rgba(0,0,0,0.1);
		font-family: "Segoe UI", sans-serif;
	}
</style>

</head>
<body>
	<h1 style="text-align: center">${title}</h1>
	<c:if test="${qCnt != 0}">
		<div class="card-container">
		<c:forEach var="question" items="${questions}" varStatus="status">
			<a href="/questionOne?questionId=${question.questionId}" style="text-decoration: none; color: inherit;">
				<div class="card">
					<h3>문제 ${question.questionNo}</h3>
					<h4>${question.questionTitle}</h4>
					<p>${question.questionText}</p>
					<p>정답 ${question.correctNo}번</p>
				</div>
			</a>
		</c:forEach>
	</c:if>
	<c:if test="${qCnt == 0}">
		<button type="button" onclick="location.href='/addQuestion?examId=${examId}'">문제 등록</button>
	</c:if>
</div>
<script>
	
</script>
</body>
</html>