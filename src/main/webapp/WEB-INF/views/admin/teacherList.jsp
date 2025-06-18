<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>강사 리스트</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<style>
	  .container {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    margin-top: 30px;
	  }
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
	<div class="container">
		<h1>강사 리스트</h1>		
		<table border="1">
			<tr>
				<th>이름</th>
				<th>전화번호</th>
				<th>주민번호</th>
				<th>주소</th>
				<th>이메일</th>
				<th>아이디</th>
				<th>담당강의</th>
				<th>선택</th>
			</tr>
			<c:forEach var="teacher" items="${teacherList}">
				<tr>
					<td>${teacher.name}</td>
					<td>${teacher.phone}</td>
					<td>${teacher.sn}</td>
					<td>${teacher.address}</td>
					<td>${teacher.email}</td>
					<td>${teacher.teacherId}</td>
					<td>
						<c:choose>
						    <c:when test="${empty teacher.courseName}">
						    	미정
						    </c:when>
						    <c:otherwise>
						    	${teacher.courseName}
						    </c:otherwise>
					  </c:choose>
					</td>
					<td><input type="checkbox" class="selectTeacher" value="${teacher.teacherId}"></td>
				</tr>
			</c:forEach>
		</table>
		
		<div style="text-align: right; margin-top: 10px;">
			<button type="button" id="insertTeacher">
				➕ 강사 등록
			</button>
			<button type="button" id="modifyBtn">
				💾 수정
			</button>
			<button type="button" id="removeBtn">
				❌ 삭제
			</button>
			
		</div>
	</div>
	
	<script>
		$("#insertTeacher").click(function(){
			window.location = "insertTeacher";
		})
		
		$("#updateTeacher").click(function(){
			window.location = "updateTeacher";
		})
	</script>
</body>
</html>