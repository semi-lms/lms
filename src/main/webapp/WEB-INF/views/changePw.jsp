<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<h1>비밀번호 변경</h1>
	<form method="post" action="/changePw">
		<table border="1">
			<tr>
				<th>변경 비밀번호</th>
				<th>
					<input type="password" id="pw" name="pw">
				</th>
			</tr>
			<tr>
				<th>변경 비밀번호 확인</th>
				<th>
					<input type="password" id="pwCk" name="pwCk">
				</th>
			</tr>
			<tr>
				<th>임시 코드</th>
				<th>
					<input type="text" id="tempPw" name="tempPw">
				</th>
			</tr>
		</table>
		<button type="submit">변경하기</button>
	</form>
</body>
</html>