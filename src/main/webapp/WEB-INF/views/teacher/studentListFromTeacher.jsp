<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반 학생 리스트</title>
<style>
/* ===== 기본 레이아웃 ===== */
.container {
	display: flex;
	min-height: 100vh;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background-color: white;
}

.main-content {
	margin-left: 300px;
	flex-grow: 1;
	padding: 30px;
	background-color: white;
}

/* ===== 상단 메뉴 (공통 탭) ===== */
.top-menu {
	margin-bottom: 20px;
}

.top-menu a {
	display: inline-block;
	padding: 8px 16px;
	margin-right: 10px;
	border-radius: 6px;
	text-decoration: none;
	font-weight: bold;
	font-size: 14px;
}

.top-menu a.active {
	background-color: #cce5ff;
	color: #004085;
}

.top-menu a.inactive {
	background-color: #e9ecef;
	color: #333;
}

/* ===== 표 (공통 테이블) ===== */
table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	background-color: #fff;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
	font-size: 14px;
}

th, td {
	border: 1px solid #ccc;
	padding: 12px 15px;
	text-align: center;
	color: #333;
	word-break: keep-all;
}

th {
	background-color: #2c3e50;
	color: white;
	font-weight: 600;
}

tr:nth-child(even) {
	background-color: #f9f9f9;
}

tr:hover {
	background-color: #e9f0ff;
}

td input[type="text"],
td input[type="date"] {
	width: 95%;
	padding: 4px;
	font-size: 13px;
	box-sizing: border-box;
}

/* ===== 버튼 ===== */
button {
	margin-right: 8px;
	padding: 5px 10px;
	font-size: 14px;
	cursor: pointer;
	border: 1px solid #333;
	border-radius: 4px;
	background-color: white;
	color: #333;
	transition: background-color 0.2s ease;
}

button:hover {
	background-color: #f0f0f0;
}

/* ===== 링크 ===== */
a {
	color: #007bff;
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
}

/* ===== 페이징 ===== */
.paging, .pagination {
	margin-top: 30px;
	display: flex;
	justify-content: center;
	gap: 8px;
}

.paging a, .pagination a,
.paging .current-page, .pagination span {
	display: inline-block;
	padding: 8px 12px;
	border: 1px solid #2c3e50;
	border-radius: 6px;
	text-decoration: none;
	font-size: 14px;
	color: #2c3e50;
	font-weight: 500;
}

.paging a:hover, .pagination a:hover {
	background-color: #ecf0f1;
}

.paging .current-page, .pagination .current-page, .pagination .current {
	background-color: #2c3e50;
	color: white;
	font-weight: bold;
	cursor: default;
}

/* ===== 모달 (시험 등록용) ===== */
#examPopup {
	display: none;
	position: fixed;
	top: 30%;
	left: 40%;
	background: white;
	padding: 20px;
	border: 1px solid #ccc;
	box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
	z-index: 1000;
}
</style>
</head>
<body>

<div class="container">
	<div class="sidebar">
		<jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
	</div>

	<div class="main-content">
		<div class="top-menu">
			<c:set var="currentPath" value="${pageContext.request.requestURI}" />

			<a href="/attendanceList?courseId=${courseId}"
			   class="${fn:contains(currentPath, '/attendanceList') ? 'active' : 'inactive'}">출결 관리</a>

			<a href="/studentListFromTeacher?courseId=${courseId}"
			   class="${fn:contains(currentPath, '/studentListFromTeacher') ? 'active' : 'inactive'}">학생 관리</a>

			<a href="/examList?courseId=${courseId}"
			   class="${fn:contains(currentPath, '/examList') ? 'active' : 'inactive'}">시험 관리</a>
		</div>

		<h2>${courseName}</h2>
		<table>
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

		<div class="pagination">
			<c:forEach var="i" begin="1" end="${endPage}">
				<c:choose>
					<c:when test="${i == currentPage}">
						<span class="current-page">${i}</span>
					</c:when>
					<c:otherwise>
						<a href="/studentListFromTeacher?courseId=${courseId}&currentPage=${i}">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
	</div>
</div>



</div>
</body>
</html>