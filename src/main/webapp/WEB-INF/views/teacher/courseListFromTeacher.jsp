<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강사-강의리스트</title>
<style>
body {
  margin: 0;
  padding: 0;
  font-family: '맑은 고딕', sans-serif;
  background-color: #f5f6fa;
}

.container {
  display: flex;
  width: 100%;
  min-height: 100vh;
}


/* 본문 */
.main-content {
  flex: 1;
  padding: 40px 60px 60px 300px;
  background-color: #fff;
}

/* 제목 */
.main-content h1 {
  font-size: 26px;
  margin-bottom: 30px;
  color: #2c3e50;
}

/* 필터 버튼 */
form {
  margin-bottom: 30px;
}

form button {
  padding: 8px 18px;
  margin-right: 10px;
  border: 1px solid black;
  background-color: white;
  color: black;
  border-radius: 5px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.2s;
}

form button:hover {
  background-color: #ccc;
}

form button:disabled {
  background-color: #ccc;
  cursor: default;
}

/* 테이블 */
table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
  margin-bottom: 30px;
}

th, td {
  padding: 14px;
  border: 1px solid #ddd;
  text-align: center;
  font-size: 15px;
}

th {
  background-color: #34495e;
  color: #fff;
}

tr:hover {
  background-color: #f0f8ff;
}

a {
  text-decoration: none;
  color : black;
  
}

a:hover {
  text-decoration: underline;
}

/* 페이징 */
.main-content > span,
.main-content > a {
  margin-right: 6px;
  font-size: 15px;
  color: #333;
}

.main-content > span {
  font-weight: bold;
  color: #3498db;
}
	.pagination {
  margin-top: 30px;
  display: flex;
  justify-content: center; /* 가운데 정렬 핵심 */
  gap: 8px; /* 버튼 사이 간격 */
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
		<h1>강의 리스트</h1>
		<form method="get" action="/courseListFromTeacher">
			<input type="hidden" name="teacherNo" value="${teacherNo}" />
			<input type="hidden" name="currentPage" value="${currentPage}" />
			<button type="submit" name="filter" value="전체" ${filter == '전체' ? 'disabled' : ''}>전체</button>
			<button type="submit" name="filter" value="예정" ${filter == '예정' ? 'disabled' : ''}>예정</button>
			<button type="submit" name="filter" value="진행중" ${filter == '진행중' ? 'disabled' : ''}>진행중</button>
			<button type="submit" name="filter" value="완료" ${filter == '완료' ? 'disabled' : ''}>완료</button>
		</form>
	
		<table border="1">
			<tr>
				<th>과정명</th>
				<th>시작일</th>
				<th>종료일</th>
				<th>진행상태</th>
			</tr>
			<c:forEach var="course" items="${courses}">
				<tr>
					<td><a href="/attendanceList?courseId=${course.courseId}">${course.courseName}</a></td>
					<td>${course.startDate}</td>
					<td>${course.endDate}</td>
					<td>${course.courseActive}</td>
				</tr>
			</c:forEach>
		</table>
		<c:forEach var="i" begin="${startPage}" end="${endPage}">
    <c:choose>
      <c:when test="${i == currentPage}">
        <span class="current">${i}</span>
      </c:when>
      <c:otherwise>
        <a href="?currentPage=${i}&searchOption=${searchOption}&keyword=${keyword}">${i}</a>
      </c:otherwise>
    </c:choose>
  </c:forEach>
	</div>
</div>
</body>
</html>