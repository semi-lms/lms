<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>공지사항 작성</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
</head>
<body>
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/${loginUser.role}SideBar.jsp" />
  </div>
  <div class="main-content">
    <h2>공지사항 작성</h2>
    <form method="post" action="${pageContext.request.contextPath}/notice/insertNotice" onsubmit="return validateForm()">
      <div class="form-group">
        <label>작성자</label>
        <input type="text" class="form-control" value="관리자" readonly>
        <input type="hidden" name="adminId" value="${loginUser.adminId}">
      </div>
      <div class="form-group">
        <label>제목</label>
        <input type="text" id="title" name="title" class="form-control" placeholder="제목을 입력해주세요.">
      </div>
      <div class="form-group">
        <label>내용</label>
        <textarea id="content" name="content" rows="10" class="form-control" placeholder="내용을 입력해주세요."></textarea>
      </div>
      <div class="form-group">
        <button type="submit" class="btn-submit">➕ 등록</button>
        <a href="${pageContext.request.contextPath}/notice/noticeList" class="btn-submit">돌아가기</a>
      </div>
    </form>
  </div>
  <script>
    function validateForm() {
      const title = document.getElementById("title").value.trim();
      const content = document.getElementById("content").value.trim();
      if (title === "" || content === "") {
        alert("제목과 내용을 입력해주세요");
        return false;
      }
      return true;
    }
  </script>
</body>
</html>
