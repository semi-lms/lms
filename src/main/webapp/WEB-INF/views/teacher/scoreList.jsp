<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
		background-color: white;;
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
				문제 관리
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
			
		<h1>성적 리스트</h1>
		<form method="get" action="/scoreList?examId=${examId}">
			<input type="hidden" name="examId" value="${examId}" />
			<input type="hidden" name="courseId" value="${courseId}" />
			<input type="hidden" name="currentPage" value="1" />
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
					<td>
						<c:choose>
							<c:when test="${sc.score != null}">
								<a href="/scoreOne?examId=${examId}&submissionId=${sc.submissionId}" 
								   style="text-decoration: none; color: #007bff; cursor: pointer;">
									${sc.score}
								</a>
							</c:when>
							<c:otherwise>
								미제출
							</c:otherwise>
						</c:choose>
					</td>
					<td>${sc.submitDate == null ? '미제출' : sc.submitDate}</td>
				</tr>
			</c:forEach>
		</table>
		<c:forEach var="i" begin="1" end="${lastPage}">
			<c:choose>
				<c:when test="${i == currentPage }">
					<span>[${i}]</span>
				</c:when>
				<c:otherwise>
					<a href="/scoreList?examId=${examId}&currentPage=${i}&filter=${filter}">[${i}]</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</div>
</div>
</body>
</html>