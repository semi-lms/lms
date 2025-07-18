<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>강사 등록 페이지</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<style>
		body {
			font-family: 'Arial', sans-serif;
			margin: 0;
			padding: 0;
			background-color: #f4f4f4;
		}
		.container {
			display: flex;
			min-height: 100vh;
		}
		.sidebar {
			width: 240px;
			background-color: #2c3e50;
			color: white;
			padding: 20px;
			box-sizing: border-box;
		}
		.main-content {
			flex: 1;
			padding: 40px;
			background-color: #ecf0f1;
		}
		.main-content h1 {
			text-align: center;
			margin-bottom: 30px;
			color: #2c3e50;
		}
		form {
			background-color: #fff;
			padding: 30px;
			border-radius: 12px;
			box-shadow: 0 4px 12px rgba(0,0,0,0.1);
			max-width: 700px;
			margin: 0 auto;
			box-sizing: border-box;
		}
		table {
			width: 100%;
			border-collapse: collapse;
		}
		th, td {
			padding: 12px;
			text-align: left;
			vertical-align: middle;
		}
		th {
			width: 30%;
			color: #2c3e50;
			font-weight: bold;
		}
		td {
			width: 70%;
		}
		input[type="text"],
		select {
			width: 100%;
			padding: 10px;
			font-size: 14px;
			border: 1px solid #ccc;
			border-radius: 6px;
			box-sizing: border-box;
		}
		button[type="submit"] {
			width: 100%;
			padding: 14px;
			background-color: #2c3e50;
			color: white;
			border: none;
			border-radius: 8px;
			font-size: 16px;
			cursor: pointer;
			margin-top: 20px;
			transition: background-color 0.3s ease;
		}
		button[type="submit"]:hover {
			background-color: #2980b9;
		}
	</style>
</head>
<body>
<div class="container">
	<div class="sidebar">
		<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
	</div>
	<div class="main-content">
		<h1>강사 등록 페이지</h1>		
		
		<form action="${pageContext.request.contextPath}/admin/insertTeacher" method="post" id="insertTeacherForm">
			<table border="0">
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
			<button type="submit">등록</button>
		</form>
	</div>
</div>

<script>
	$("form").on("submit", function (e) {
		e.preventDefault();  // 기본 전송 막기
		
		let valid = true;

		const phone = $("input[name='phone']").val().replace(/-/g, "");
		const sn = $("input[name='sn']").val().trim();
		const email = $("input[name='email']").val().trim();

		// 전화번호 유효성 검사
		if (!/^01[016789][0-9]{7,8}$/.test(phone)) {
			alert("전화번호 형식이 올바르지 않습니다.");
			valid = false;
		}

		// 주민번호 유효성 검사
		if (!/^[0-9]{6}-?[0-9]{7}$/.test(sn)) {
			alert("주민번호 형식이 올바르지 않습니다.");
			valid = false;
		}

		// 이메일 유효성 검사
		if (email && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
			alert("이메일 형식이 올바르지 않습니다.");
			valid = false;
		}

		if (!valid) return;
		
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

	
	// 전화번호 자동 하이픈
	$("#phoneInput").on("input", function () {
		let v = $(this).val().replace(/[^0-9]/g, "");
		let formatted = v;
		if (v.length < 4) formatted = v;
		else if (v.length < 8) formatted = v.substr(0, 3) + "-" + v.substr(3);
		else if (v.length <= 11) formatted = v.substr(0, 3) + "-" + v.substr(3, 4) + "-" + v.substr(7);
		else formatted = v.substr(0, 3) + "-" + v.substr(3, 4) + "-" + v.substr(7, 4);
		$(this).val(formatted);

		// ID/비밀번호 자동 설정
		if (v.length >= 4) {
			const pw = v.slice(-4);
			$("#password").val(pw);
			$("#teacherId").val(randomId(6));
		} else {
			$("#password").val('');
			$("#teacherId").val('');
		}
	});
	
	
	// 주민번호 자동 하이픈
	$("input[name='sn']").on("input", function () {
		let val = $(this).val().replace(/[^0-9]/g, ""); // 숫자만
		if (val.length <= 6) {
			$(this).val(val);
		} else if (val.length <= 13) {
			$(this).val(val.substr(0, 6) + "-" + val.substr(6));
		} else {
			$(this).val(val.substr(0, 6) + "-" + val.substr(6, 7));
		}
	});
</script>
</body>
</html>
