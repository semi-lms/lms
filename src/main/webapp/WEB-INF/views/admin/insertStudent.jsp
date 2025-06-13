<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
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
	min-width: 220px; /* 필요시 사이드바 너비 늘리세요 */
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
			<h1>학생 등록 페이지</h1>
			<form action="/admin/insertStudent" method="post">
				<select id="chooseCourse">
					<option>강의 선택</option>
				</select>
				<table border="1">
					<tr>
						<th>이름</th>
						<th>전화번호</th>
						<th>주민번호</th>
						<th>주소</th>
						<th>이메일</th>
						<th>초기 아이디</th>
						<th>초기 비밀번호</th>
					</tr>
					<tr>
					    <td><input type="text" name="studentList[0].name"></td>
					    <td><input type="text" name="studentList[0].phone"></td>
					    <td><input type="text" name="studentList[0].sn"></td>
					    <td><input type="text" name="studentList[0].address"></td>
					    <td><input type="email" name="studentList[0].email"></td>
					    <td><input type="text" name="studentList[0].studentId"></td>
					    <td><input type="text" name="studentList[0].password"></td>
					</tr>
				</table>
				<button type="button" id="insertRowBtn">행 추가</button>
				<button type="submit">등록하기</button>
			</form>
		</div>
	</div>
<script>
	$("#insertRowBtn").click(function(){
	    $("table").append(`
   			<tr>
	    	    <td><input type="text" name="studentList[0].name"></td>
	    	    <td><input type="text" name="studentList[0].phone"></td>
	    	    <td><input type="text" name="studentList[0].sn"></td>
	    	    <td><input type="text" name="studentList[0].address"></td>
	    	    <td><input type="email" name="studentList[0].email"></td>
	    	    <td><input type="text" name="studentList[0].studentId"></td>
	    	    <td><input type="text" name="studentList[0].password"></td>
	    	</tr>
	        `);
	})
</script>
</body>
</html>