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
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background-color: white;;
	justify-content: center; /* 가로 중앙 정렬 */
}


.main-content {
	max-width: 900px;  /* 최대 넓이 제한 */
	width: 100%;
	padding: 30px 40px 40px 40px; /* 콘텐츠 여백 */
	background-color: white;
	box-sizing: border-box;
	min-height: 100vh;
	margin-left: 20px; /* 사이드바와 간격 */
}



table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	background-color: #fff;
	box-shadow: 0 0 10px rgba(0,0,0,0.05);
}

th, td {
	border: 1px solid #ccc;
	padding: 12px 15px;
	text-align: center;
	font-size: 14px;
	color: #333;
}

th {
	background-color: #f8f9fa;
	font-weight: 600;
}

tr:nth-child(even) {
	background-color: #f9f9f9;
}

tr:hover {
	background-color: #e9f0ff;
}

a {
	color: #007bff;
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
}

/* 페이징 */
.pagination {
  margin-top: 30px;
  display: flex;
  justify-content: center;
  gap: 8px;
}

.pagination a,
.pagination span {
  display: inline-block;
  padding: 8px 12px;
  border: 1px solid #343e4a;
  border-radius: 6px;
  color: #343e4a;
  text-decoration: none;
  font-weight: 500;
}

.pagination a:hover {
  background-color: #d6dce2;
}

.pagination .current-page,
.pagination .current {
  background-color: #343e4a;
  color: white;
  font-weight: bold;
  pointer-events: none;
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
	<div class="pagination">
  <c:forEach var="i" begin="1" end="${endPage}">
    <c:choose>
      <c:when test="${i == currentPage}">
        <span>${i}</span>
      </c:when>
      <c:otherwise>
        <a href="/studentListFromTeacher?courseId=${courseId}&currentPage=${i}">${i}</a>
      </c:otherwise>
    </c:choose>
  </c:forEach>
</div>

	</div>
</div>
</body>
</html>