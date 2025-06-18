<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반 학생 리스트</title>
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
		<!-- 공통 페이지 상단 메뉴 -->
		<div style="margin-bottom: 20px;">
			<c:set var="currentPath" value="${pageContext.request.requestURI}" />

			<a href="/attendanceList?courseId=${courseId}" 
				style="padding: 8px 16px; 
					margin-right: 10px; 
					border-radius: 6px; 
					text-decoration: none; 
					font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/attendanceList")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/attendanceList")}'>background-color: #e9ecef; color: #333;</c:if>">
				출결 관리
			</a>

			<a href="/studentListFromTeacher?courseId=${courseId}" 
				style="padding: 8px 16px; 
				   margin-right: 10px; 
				   border-radius: 6px; 
				   text-decoration: none; 
				   font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/studentListFromTeacher")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/studentListFromTeacher")}'>background-color: #e9ecef; color: #333;</c:if>">
				학생 관리
			</a>

			<a href="/examList?courseId=${courseId}" 
				style="padding: 8px 16px; 
					border-radius: 6px; 
					text-decoration: none; 
					font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/examList")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/examList")}'>background-color: #e9ecef; color: #333;</c:if>">
				시험 관리
			</a>
		</div>
		
		<h1>반 학생 리스트</h1>
		<table border="1">
			<tr>
				<th>이름</th>
				<th>생년월일</th>
				<th>성별</th>
				<th>메일</th>
				<th>전화번호</th>
			</tr>
			<c:forEach var="st" items="${students}">
				<tr>
					<td>${st.name}</td>
					<td>${st.birth}</td>
					<td>${st.gender}</td>
					<td>${st.email}</td>
					<td>${st.phone}</td>
				</tr>
			</c:forEach>
		</table>
		<c:forEach var="i" begin="1" end="${endPage}">
			<c:choose>
				<c:when test="${i == currentPage}">
					<span>[${i}]</span>
				</c:when>
				<c:otherwise>
					<a href="/studentListFromTeacher?courseId=${courseId}&currentPage=${i}">[${i}]</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</div>
</div>
</body>
</html>