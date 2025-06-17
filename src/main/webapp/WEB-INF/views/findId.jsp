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
	<h1>아이디 찾기</h1>
	<form id="findIdForm" method="post" action="/findId">
		<table border="1">
			<tr>
				<th>이름</th>
				<th>
					<input type="text" id="findIdByName" name="findIdByName">
				</th>
			</tr>
			<tr>
				<th>이메일</th>
				<th>
					<input type="email" id="findIdByEmail" name="findIdByEmail">
				</th>
			</tr>
		</table>
		<button type="button" onclick="location.href='/login'">되돌아가기</button>
		<button type="submit">확인</button>
	</form>
<script>
    $("#findIdForm").on("submit", function(e){
        e.preventDefault();
        let name = $("#findIdByName").val().trim();
        let email = $("#findIdByEmail").val().trim();
        if(!name || !email){
            alert("이름과 이메일을 모두 입력 안 하고 뭘 찾겠다는거야");
            return;
        }
        $.ajax({
            url:"/findId",
            type:"post",
            data:{
                findIdByName : name,
                findIdByEmail : email
            },
            success: function(result){
                if(result && result!="NOT_FOUND"){
                    alert("회원님의 아이디는 " + result + "이거에용");
                    window.location.href = "/login"; // 로그인 페이지로 이동
                } else {
                    alert("일치하는 정보가 없네용? 간첩이세요?");
                }
            }
        });
    });
</script>
</body>
</html>