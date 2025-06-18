<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>공지사항 수정</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
</head>
<body>

  <!-- 왼쪽 메뉴 -->
  <div class="sidebar">
    <c:choose>
      <c:when test="${loginUser.role eq 'admin'}">
        <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
      </c:when>
    </c:choose>
  </div>

  <!-- 본문 -->
  <div class="main-content">
    <div class="notice-content">
      <h2>공지사항 수정</h2>

      <form method="post"
            action="${pageContext.request.contextPath}/notice/updateNotice"
            onsubmit="return validateForm()">

        <!-- 숨겨진 공지 ID -->
        <input type="hidden" name="noticeId" value="${notice.noticeId}">

        <div class="form-group">
          <label>작성자</label>
          <input type="text" value="관리자" class="form-control" readonly>
        </div>

        <div class="form-group">
          <label for="title">제목</label>
          <input type="text" id="title" name="title" value="${notice.title}" class="form-control" placeholder="제목을 입력해주세요.">
        </div>

        <div class="form-group">
          <label for="content">내용</label>
          <textarea id="content" name="content" rows="10" class="form-control" placeholder="내용을 입력해주세요.">${notice.content}</textarea>
        </div>

        <div class="form-group">
          <button type="submit" class="btn-submit">수정 완료</button>
        </div>

        <div class="form-group">
          <a href="${pageContext.request.contextPath}/notice/noticeOne?noticeId=${notice.noticeId}">
            <button type="button" class="btn-submit">돌아가기</button>
          </a>
        </div>

      </form>
    </div>
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
