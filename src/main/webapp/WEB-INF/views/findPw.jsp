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
            <!-- 역할 선택 -->
            <div class="form-group">
                <label for="role">구분</label>
                <select id="role" name="role" class="short-input">
                    <option value="">선택</option>
                    <option value="student">학생</option>
                    <option value="teacher">강사</option>
                </select>
                <span id="roleError" class="error"></span>
            </div>
            
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name=name class="short-input">
                 <span id="nameError" class="error"></span>  <!-- 실시간 오류 메시지 표시 -->
            </div>
            <div class="form-group">
                <label for="userId">아이디</label>
                <input type="text" id="userId" name="userId" class="short-input">
                 <span id="idError" class="error"></span>  <!-- 실시간 오류 메시지 표시 -->
            </div>
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" class="short-input">
                <span id="emailError" class="error"></span> <!-- 실시간 오류 메시지 표시 -->
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
	
	// 아이디 형식
	function isValidId(id) {
  	 const idRegex = /^[a-z0-9]{4,20}$/;
  	 return idRegex.test(id);
  
}
	// 이메일 형식 정규표현식
	function isValidEmail(email) {
	  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	  return emailRegex.test(email);
	}
	
	// 이름 형식
	function isValidName(name) {
		  const nameRegex = /^[가-힣a-zA-Z]{2,20}$/; // 한글+영문, 2~20자
		  return nameRegex.test(name);
		}
	
	
	// 실시간 이름 유효성 검사
	$("#name").on("input", function () {
	  const name = $(this).val().trim();
	  if (name === "") {
		$("#nameError").text(""); // 입력 비었을 때 메시지도 제거
	  } else if (!isValidName(name)) {
	    $("#nameError").text("한글 또는 영문 2~20자 이내로 입력하세요.");
	  } else {
	    $("#nameError").text(""); // 통과 시 오류 제거
	  }
	});
	
	// 아이디 유효성 검사
	$("#userId").on("input", function () {
		  const id = $(this).val().trim();
		  if (id === "") {
		    $("#idError").text("");
		  } else if (!isValidId(id)) {
		    $("#idError").text("영문+숫자 조합 4~20자로 입력하세요.");
		  } else {
		    $("#idError").text("");
		  }
		});
	
	// 실시간 이메일 유효성 검사
	$("#email").on("input", function () {
	  const email = $(this).val().trim();
	  if (email === "") {
		$("#emailError").text(""); // 입력 비었을 때 메시지도 제거
	  } else if (!isValidEmail(email)) {
	    $("#emailError").text("올바른 이메일 형식이 아닙니다.");
	  } else {
	    $("#emailError").text(""); // 통과 시 오류 제거
	  }
	});
	
	$(document).ready(function () {

		  // 역할 선택 시 에러 메시지 제거
		  $("#role").on("change", function () {
		    const role = $(this).val();
		    if (role) {
		      $("#roleError").text("");
		    }
		  });

	
	// 폼 형식 제출
    $("#findPwForm").on("submit", function(e){
        e.preventDefault();
        const name = $("#name").val().trim();
        const userId = $("#userId").val().trim();
        const email = $("#email").val().trim();
        const role = $("#role").val();

        if (!role) {
            $("#roleError").text("학생 또는 강사를 선택해주세요.");
            return;
          }
        
        if (!name || !userId || !email) {
            alert("이름, 아이디, 이메일 모두 입력하세요.");
            return;
        }
        if (!isValidName(name)) {
            alert("이름 형식이 올바르지 않습니다.");
            return;
        }
        if (!isValidId(userId)) {
            alert("아이디 형식이 올바르지 않습니다.");
            return;
        }
        if (!isValidEmail(email)) {
            alert("이메일 형식이 올바르지 않습니다.");
            return;
        }
        
     // AJAX 내부에서 data 객체 생성
     // if문을 쓰기위해 
		const data = {
			name: name,
			userId: userId,
			email: email,
			role: role
     };
        
        $.ajax({
            url:"/findPw",
            type:"post",
            data: data,
            success: function(result){
                if(result && result!="NOT_FOUND"){
                    window.location.href = "/changePw?studentId=" + encodeURIComponent(userId) +
                    "&role=" + encodeURIComponent(role) +
                    "&tempCode=" + encodeURIComponent(result);
                } else {
                    alert("정보가 일치하지 않습니다.");
                }
            }
         });
    	});
	 });
</script>

</body>
</html>
