<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="/css/login.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header/mainHeader.jsp" />
 <img src="/img/cursor.png" id="custom-cursor" alt="커서" />
<div class="login-wrapper">
    <div class="login-box">
        <h2>비밀번호 찾기</h2>
        <form id="findPwForm" method="post" action="/findPw">
            <div class="form-group">
                <label for="findPwByName">이름</label>
                <input type="text" id="findPwByName" name="findPwByName" class="short-input">
            </div>
            <div class="form-group">
                <label for="findPwById">아이디</label>
                <input type="text" id="findPwById" name="findPwById" class="short-input">
            </div>
            <div class="form-group">
                <label for="findPwByEmail">이메일</label>
                <input type="email" id="findPwByEmail" name="findPwByEmail" class="short-input">
            </div>
            <button type="submit" class="submit-btn">확인</button>
            <button type="button" onclick="location.href='/login'" class="submit-btn" style="background:#ccc; color:#444; margin-top:10px;">되돌아가기</button>
        </form>
        <div class="link-buttons">
            <a href="/findId">아이디 찾기</a>
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
	
    $("#findPwForm").on("submit", function(e){
        e.preventDefault();
        let name = $("#findPwByName").val().trim();
        let id = $("#findPwById").val().trim();
        let email = $("#findPwByEmail").val().trim();
        if(!name || !id || !email){
            alert("이름, 아이디, 이메일 모두 입력해야함");
            return;
        }
        $.ajax({
            url:"/findPw",
            type:"post",
            data:{
                findPwByName : name,
                findPwById : id,
                findPwByEmail : email
            },
            success: function(result){
                if(result && result!="NOT_FOUND"){
                    window.location.href = "/changePw";
                } else {
                    alert("정보가 일치하지 않습니다.");
                }
            }
        });
    });

</script>

</body>
</html>
