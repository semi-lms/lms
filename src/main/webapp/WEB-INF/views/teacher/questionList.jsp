<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	.container {
		display: flex;
		min-height: 100vh;
		font-family: 'Segoe UI', sans-serif;
		background-color: #f0f0f0;
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
		<!-- 공통 페이지 상단 메뉴 -->
		<div style="margin-bottom: 20px;">
			<c:set var="currentPath" value="${pageContext.request.requestURI}" />

			<a href="/questionList?examId=${examId}" 
				style="padding: 8px 16px; 
					margin-right: 10px; 
					border-radius: 6px; 
					text-decoration: none; 
					font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/questionList")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/questionList")}'>background-color: #e9ecef; color: #333;</c:if>">
				시험 관리
			</a>

			<a href="/scoreList?examId=${examId}" 
				style="padding: 8px 16px; 
				   margin-right: 10px; 
				   border-radius: 6px; 
				   text-decoration: none; 
				   font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/scoreList")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/scoreList")}'>background-color: #e9ecef; color: #333;</c:if>">
				성적 관리
			</a>
		</div>
			
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
			<button type="button" onclick="location.href='/addQuestion?examId=${examId}'">➕ 문제 등록</button>
		</c:if>
	</div>
</div>
</body>
</html>