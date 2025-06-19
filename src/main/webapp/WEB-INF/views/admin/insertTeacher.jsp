<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>강사 등록 페이지</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<style>
		form, h1 {
		   display: flex;
		   flex-direction: column;
		   align-items: center;
		   margin-top: 30px;
		}
		 
	 	input, select {
			width: 300px;
			padding: 5px;
			box-sizing: border-box;
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
	<h1>강사 등록 페이지</h1>		
	
	<form action="${pageContext.request.contextPath}/admin/insertTeacher" method="post">
		<table border="1">
			<tr>
				<th>이름</th>
				<td><input type="text" name="name" required></td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td><input type="text" name="phone" id="phoneInput" placeholder="ex) 010-0000-0000" required></td>
			</tr>
			<tr>
				<th>주민번호</th>
				<td><input type="text" name="sn" placeholder="ex) 870701-2345678" required></td>
			</tr>
			<tr>
				<th>주소</th>
				<td><input type="text" name="address" required></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" name="email" required></td>
			</tr>
			<tr>
				<th>담당 강의</th>
				<td>
					<select name="courseId" required>
						<option value="" disabled selected>강의를 선택하세요</option>
						<option value="0">미정</option>
						<c:forEach var="course" items="${courseList}">
							<option value="${course.courseId}">${course.courseName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>초기 아이디</th>
				<td><input type="text" name="teacherId" id="teacherId" readonly></td>
			</tr>
			<tr>
				<th>초기 비밀번호</th>
				<td><input type="text" name="password" id="password" readonly></td>
			</tr>		
		</table>
		<br>
		<button type="submit">등록</button>
	</form>
	
	<script>
		$("form").on("submit", function (e) {
			e.preventDefault();  // 기본 전송 막기
			
			const formData = $(this).serialize();
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/insertTeacher",
				type: "POST",
				data: formData,
				success: function (response) {
					if (response.success) {
						alert("등록 완료");
						window.location.href = "${pageContext.request.contextPath}/admin/teacherList";
					} else {
						alert(response.message);
					}
				},
				error: function () {
					alert("서버 오류 발생");
				}
			});
		});
	
		// 아이디 6자리로 랜덤하게 부여
		function randomId(length = 6) {
			const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
			let result = "";
			for (let i = 0; i < length; i++) {
				result += chars.charAt(Math.floor(Math.random() * chars.length));
			}
			return result;
		}

		// 전화번호 입력 시 자동 ID/비밀번호 설정
		$("#phoneInput").on("input", function () {
			const phone = this.value.replace(/[^0-9]/g, "");
			if (phone.length >= 4) {
				const pw = phone.slice(-4);
				$("#password").val(pw);
				$("#teacherId").val(randomId(6));
			} else {
				$("#password").val('');
				$("#teacherId").val('');
			}
		});
	</script>
</body>
</html>