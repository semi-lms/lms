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
			<button type="button" id="insertStudent">학생등록</button><br>
			
			<select name="searchOption">
				<option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
				<option value="studentName" ${searchOption == 'studentName' ? 'selected' : ''}>이름</option>
				<option value="courseName" ${searchOption == 'courseName' ? 'selected' : ''}>수강과목</option>
			</select>
			<input type="text" name="keyword" id="keyword">
			<button type="submit" id="keyword">검색</button>
		</form>
		
		<c:if test="${page.lastPage>1}">
			<c:if test="${startPage>1}">
				<a href="/admin/studentList?currentPage=${startPage-1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[이전]</a>
			</c:if>
		</c:if>
		
		<c:forEach var="i" begin="${startPage}" end="${endPage}">
			<c:choose>
				<c:when test="${i == page.currentPage }">
					<span>[${i}]</span>
				</c:when>
				<c:otherwise>
					<a href="/admin/studentList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[${i}]</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		
		<c:if test="${endPage < page.lastPage}">
			<a href="/admin/studentList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[다음]</a>
		</c:if>
    </div>
</div>
<script>
	$("#insertStudent").click(function(){
		window.location = "insertStudent";
	})
</script>
</body>
</html>