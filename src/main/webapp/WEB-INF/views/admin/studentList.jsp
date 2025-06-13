<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<style>
body {
  margin: 0;
  padding: 0;
}
.container {
  display: flex;
  width: 100%;
}
.sidebar {
  min-width: 220px;   /* 필요시 사이드바 너비 늘리세요 */
  background: #fafafa;
  height: 100vh;
}
.chart-container {
  margin-top: 32px;
}
.main-content {
  flex: 1;
  background: #fff;
  padding: 40px 40px 40px 300px; /* 왼쪽 패딩을 140px로 늘림 */
}
</style>
<body>
<div class="container">
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
  </div>
  <div class="main-content">
	<h1>학생 리스트</h1>
		<form action="/admin/studentList" method="get">
			<table border="1">
				<tr>
					<th>이름</th>
					<th>전화번호</th>
					<th>주민번호</th>
					<th>주소</th>
					<th>이메일</th>
					<th>아이디</th>
					<th>수강과목</th>
				</tr>
				<c:forEach var="sList" items="${studentList}">
				<tr>
					<td>${sList.name }</td>	
					<td>${sList.phone }</td>	
					<td>${sList.sn }</td>	
					<td>${sList.address }</td>	
					<td>${sList.email }</td>	
					<td>${sList.studentId }</td>	
					<td>${sList.courseName }</td>	
				</tr>
				</c:forEach>
			</table>
			<select id="searchStudentOption">
				<option value="all">전체</option>
				<option value="studentName">이름</option>
				<option value="courseName">수강과목</option>
			</select>
			<input type="text" name="searchStudent" id="searchStudent">
			<button type="submit" id="searchStudentBtn">검색</button>
		</form>
    </div>
</div>
	
</body>
</html>