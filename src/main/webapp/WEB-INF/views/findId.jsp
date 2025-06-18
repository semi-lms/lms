<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" href="/css/login.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header/mainHeader.jsp" />
 <img src="/img/cursor.png" id="custom-cursor" alt="커서" />
<div class="login-wrapper">
    <div class="login-box">
        <h2>아이디 찾기</h2>
        <form id="findIdForm" method="post" action="/findId">
            <div class="form-group">
                <label for="findIdByName">이름</label>
                <input type="text" id="findIdByName" name="findIdByName" class="short-input">
            </div>
            <div class="form-group">
                <label for="findIdByEmail">이메일</label>
                <input type="email" id="findIdByEmail" name="findIdByEmail" class="short-input">
            </div>
            <button type="submit" class="submit-btn">확인</button>
            <button type="button" onclick="location.href='/login'" class="submit-btn" style="background:#ccc; color:#444; margin-top:10px;">되돌아가기</button>
        </form>
        <div class="link-buttons">
            <a href="/findPw">비밀번호 찾기</a>
        </div>
    </div>
</div>

<script>
	document.addEventListener('DOMContentLoaded', () => {
	  const cursorImg = document.getElementById('custom-cursor');
	  document.addEventListener('mousemove', function (e) {
	    cursorImg.style.left = (e.clientX + 30) + 'px';  // 마우스 x좌표 + 30px
	    cursorImg.style.top = (e.clientY + 30) + 'px';   // 마우스 y좌표 + 30px
	  });
	});
	
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
                    window.location.href = "/login";
                } else {
                    alert("일치하는 정보가 없네용? 간첩이세요?");
                }
            }
        });
    });
</script>
</body>
</html>
