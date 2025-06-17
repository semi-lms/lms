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
	<h1>비밀번호 찾기</h1>
	<form id="findPwForm" method="post" action="/findPw">
		<table border="1">
			<tr>
				<th>이름</th>
				<td>
					<input type="text" id="findPwByName" name="findPwByName">
				</td>			
			</tr>
			<tr>
				<th>아이디</th>
				<td>
					<input type="text" id="findPwById" name="findPwById">
				</td>			
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<input type="email" id="findPwByEmail" name="findPwByEmail">
				</td>			
			</tr>
		</table>
		<button type="button" onclick="location.href='/login'">되돌아가기</button>
		<button type="submit">확인</button>
	</form>
<script>
	$("#findPwForm").on("submit", function(e){
		e.preventDefault();
		let name = $("#findPwByName").val().trim();
		let id = $("#findPwById").val().trim();
		let email = $("#findPwByEmail").val().trim();
		
		if(!name || !id || !email){
			alert("전부 다 입력하고 찾아라 확 씨!")
			return;
		}
		
		$.ajax({
			url:"/findPw"
			,type:"post"
			,data:{
				findPwByName : name
				,findPwById : id
				,findPwByEmail : email
			},
			success: function(result){
				if(result && result != "NOT_FOUND"){
					window.location="/changePw"
				} else {
					alert("일치하는 정보가 없습니다.")
				}
			}
		})
	})
</script>
</body>
</html>