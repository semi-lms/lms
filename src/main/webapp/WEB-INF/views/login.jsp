<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="/css/login.css">
   
</head>
<body>
 <img src="/img/cursor.png" id="custom-cursor" alt="커서" />
 <jsp:include page="/WEB-INF/views/common/header/mainHeader.jsp" />
<div class="login-wrapper">
    <div class="login-box">
        <h2>로그인</h2>
        <form action="login" method="post">
            <div class="form-group">
                <label for="id">ID</label>
                <input type="text" id="id" name="id" class="short-input" required>
            </div>
            <div class="form-group">
                <label for="pw">비밀번호</label>
                <input type="password" id="pw" name="pw" class="short-input" required>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>

            <div class="role-buttons">
                <input type="radio" class="btn-check" name="role" id="admin" value="admin" required>
                <label class="btn-outline-role" for="admin">관리자</label>

                <input type="radio" class="btn-check" name="role" id="teacher" value="teacher">
                <label class="btn-outline-role" for="teacher">강사</label>

                <input type="radio" class="btn-check" name="role" id="student" value="student">
                <label class="btn-outline-role" for="student">학생</label>
            </div>

            <button type="submit" class="submit-btn">로그인</button>
        </form>
        <div class="link-buttons">
            <a href="/findId">아이디 찾기</a>
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
</script>
</body>
</html>
