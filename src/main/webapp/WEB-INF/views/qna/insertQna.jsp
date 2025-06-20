<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>QnA 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css"> <!-- 공지사항 css 통일 사용 -->
</head>
<body>
<fmt:setTimeZone value="Asia/Seoul" />
  
<div class="sidebar">
  <c:choose>
    <c:when test="${loginUser.role eq 'admin'}">
      <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
    </c:when>
    <c:when test="${loginUser.role eq 'teacher'}">
      <jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
    </c:when>
    <c:when test="${loginUser.role eq 'student'}">
      <jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
    </c:when>
  </c:choose>
</div>

<div class="main-content">
  <h2>QnA 작성</h2>
  
  <form method="post" action="${pageContext.request.contextPath}/qna/insertQna" class="form-area" onsubmit="return validateForm()">

    <div class="form-group">
      <label>작성자</label>
      <input type="text" class="form-control" value="${loginUser.studentId}" readonly>
      <input type="hidden" name="studentId" value="${loginUser.studentId}">
    </div>

    <div class="form-group">
      <label for="title">제목</label>
      <input type="text" name="title" id="title" class="form-control" placeholder="제목을 입력해주세요.">
      <label style="margin-top: 8px; font-weight: normal;">
        <input type="checkbox" name="isSecret" value="Y"> 비밀글
      </label>
    </div>

    <div class="form-group">
      <label for="content">내용</label>
      <textarea name="content" id="content" rows="10" class="form-control" placeholder="내용을 입력해주세요."></textarea>
    </div>

    <div class="form-group button-group">
      <button type="submit" class="btn-submit">➕ 등록</button>
      <a href="${pageContext.request.contextPath}/qna/qnaList" class="btn-submit">돌아가기</a>
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
