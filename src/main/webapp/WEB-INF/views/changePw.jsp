<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>비밀번호 변경</title>
	<link rel="stylesheet" href="/css/login.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header/mainHeader.jsp" />
<img src="/img/cursor.png" id="custom-cursor" alt="커서" />
<div class="login-wrapper">
    <div class="login-box">
        <h2>비밀번호 변경</h2>
        <form id="changePwForm" method="post" action="/changePw">
            <input type="hidden" name="studentId" value="${studentId}">
            <input type="hidden" name="role" value="${role}">

            <div class="form-group">
                <label for="pw">새 비밀번호</label>
                <input type="password" id="pw" name="pw" class="short-input" placeholder="비밀번호 입력">
                <span id="pwError" class="error"></span>
            </div>

            <div class="form-group">
                <label for="pwCk">비밀번호 확인</label>
                <input type="password" id="pwCk" name="pwCk" class="short-input" placeholder="비밀번호 재입력">
                <span id="pwCkError" class="error"></span>
            </div>

            <div class="form-group">
                <label for="tempCode">임시 코드</label>
                <input type="text" id="tempCode" name="tempCode" class="short-input" placeholder="이메일로 받은 임시 코드 입력">
                <span id="tempCodeError" class="error"></span>
            </div>

            <button type="submit" class="submit-btn">변경하기</button>
            <button type="button" onclick="location.href='/login'" class="submit-btn" style="background:#ccc; color:#444; margin-top:10px;">되돌아가기</button>
        </form>
    </div>
</div>

<script>
  // 커서 이미지
  document.addEventListener('DOMContentLoaded', () => {
    const cursorImg = document.getElementById('custom-cursor');
    document.addEventListener('mousemove', function (e) {
      cursorImg.style.left = (e.clientX + 30) + 'px';
      cursorImg.style.top = (e.clientY + 30) + 'px';
    });
  });

  // 비밀번호 정규식 검사
  function isValidPassword(pw) {
    const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*]{8,20}$/;
    return pwRegex.test(pw);
  }

  // 비밀번호 입력
  $("#pw").on("input", function () {
    const pw = $(this).val().trim();
    if (!pw) {
      $("#pwError").text("비밀번호를 입력하세요.");
    } else if (!isValidPassword(pw)) {
      $("#pwError").text("영문+숫자 포함 8~20자입니다.");
    } else {
      $("#pwError").text("");
    }
  });

  // 비밀번호 확인
  $("#pwCk").on("input", function () {
    const pw = $("#pw").val().trim();
    const pwCk = $(this).val().trim();
    if (!pwCk) {
      $("#pwCkError").text("비밀번호를 재입력하세요.");
    } else if (pw !== pwCk) {
      $("#pwCkError").text("비밀번호가 일치하지 않습니다.");
    } else {
      $("#pwCkError").text("");
    }
  });

  // 임시코드 유효성 검사 (blur 이벤트로 AJAX)
  $("#tempCode").on("blur", function () {
    const tempCode = $(this).val().trim();
    const userId = $("input[name='studentId']").val();
    const role = $("input[name='role']").val();

    if (!tempCode) {
      $("#tempCodeError").text("임시 코드를 입력하세요.");
      return;
    }

    $.ajax({
      url: "/checkTempCode",
      method: "POST",
      data: {
        userId: userId,
        role: role,
        tempCode: tempCode
      },
      success: function (response) {
        if (response === "VALID") {
          $("#tempCodeError").text("");
        } else {
          $("#tempCodeError").text("임시 코드가 유효하지 않습니다.");
        }
      },
      error: function () {
        $("#tempCodeError").text("서버 오류. 다시 시도해주세요.");
      }
    });
  });

  // 폼 제출 시 최종 유효성 검사
  $("#changePwForm").on("submit", function (e) {
    let isValid = true;
    const pw = $("#pw").val().trim();
    const pwCk = $("#pwCk").val().trim();
    const tempCode = $("#tempCode").val().trim();

    if (!pw || !isValidPassword(pw)) {
      $("#pw").trigger("input");
      isValid = false;
    }
    if (!pwCk || pw !== pwCk) {
      $("#pwCk").trigger("input");
      isValid = false;
    }
    if (!tempCode || $("#tempCodeError").text() !== "") {
      $("#tempCode").trigger("blur");
      isValid = false;
    }

    if (!isValid) {
      e.preventDefault(); // 제출 막음
    }
  });
</script>
	
</body>
</html>