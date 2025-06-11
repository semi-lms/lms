<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
  .container { display: flex; }
  .sidebar { width: 280px; padding: 7px; border-right: 1px solid #ccc; }
  .content { flex-grow: 1; padding: 20px; min-height: 400px; }
  .sidebar button, .sidebar a { display: block; margin: -10px 0; width: 100%; }

  #submenu {
    display: none;
    flex-direction: row;
    justify-content: center;
    gap: 10px;
    margin-top: -20px;
    margin-bottom: 30px;
  }

  .submenu-link {
    text-decoration: none;
    font-size: 14px;
    color: #333;
    padding: 4px 4px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }

  .submenu-link:hover {
    background-color: #f0f0f0;
    color: #007bff;
  }
</style>
</head>
<body>
<div class="container">
  <!-- 왼쪽 메뉴 -->
  <div class="sidebar">
    <c:choose>
      <c:when test="${loginUser.role eq 'admin'}">
        <jsp:include page="/WEB-INF/views/header/mypageHeaderAdmin.jsp" />
      </c:when>
      <c:when test="${loginUser.role eq 'teacher'}">
        <jsp:include page="/WEB-INF/views/header/mypageHeaderTeacher.jsp" />
      </c:when>
      <c:when test="${loginUser.role eq 'student'}">
        <jsp:include page="/WEB-INF/views/header/mypageHeaderStudent.jsp" />
      </c:when>
    </c:choose>
  </div>

  <!-- 오른쪽 콘텐츠 영역 -->
  <div class="content">
    <form id="updateForm">
      <c:choose>
        <c:when test="${loginUser.role eq 'admin'}">
          <c:set var="userId" value="${loginUser.adminId}" />
        </c:when>
        <c:when test="${loginUser.role eq 'teacher'}">
          <c:set var="userId" value="${loginUser.teacherId}" />
        </c:when>
        <c:when test="${loginUser.role eq 'student'}">
          <c:set var="userId" value="${loginUser.studentId}" />
        </c:when>
      </c:choose>

      <p>
        아이디:
        <input type="text"
               name="id"
               id="userIdInput"
               value="${userId}"
               readonly
               style="color: gray; border: 1px solid #ccc; background-color: #f9f9f9; padding: 5px;"
               onclick="clearValueOnce(this)" />
        <button type="button" onclick="checkDuplicate()">중복확인</button>
      </p>

      <p>비밀번호: <input type="password" name="newPassword" required /></p>
      <p>비밀번호 확인: <input type="password" name="confirmPassword" required /></p>
      <p>이름: <input type="text" value="${loginUser.name}" readonly /></p>
      <p>이메일: <input type="text" value="${loginUser.email}" readonly /></p>
      <p>수강과목: <input type="text" value="${loginUser.courseId}" readonly /></p>
      <p>가입일: <input type="text" value="${loginUser.regDate}" readonly /></p>

      <button type="button" onclick="submitUpdate()">수정하기</button>
    </form>
  </div>
</div>

<script>
function clearValueOnce(input) {
  if (input.hasAttribute("readonly")) {
    input.removeAttribute("readonly");
    input.value = '';
    input.style.color = "black";
    input.style.backgroundColor = "#fff";
    input.focus();
  }
}

function checkDuplicate() {
  const id = $('input[name=id]').val();
  $.get(`/check-id?id=${id}`, function(data) {
    alert(data.duplicate ? "이미 존재하는 아이디입니다." : "사용 가능한 아이디입니다.");
  });
}

function submitUpdate() {
  $.ajax({
    url: '/mypage/updateInfo',
    method: 'POST',
    data: $('#updateForm').serialize(),
    success: function(response) {
      alert("수정 완료!");
      loadContent('/mypage/info');
    },
    error: function() {
      alert("수정 실패");
    }
  });
}

function toggleSubmenu() {
  const submenu = document.getElementById('submenu');
  submenu.style.display = submenu.style.display === 'none' || submenu.style.display === '' ? 'flex' : 'none';
}
</script>
</body>
</html>