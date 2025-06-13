<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
</head>
<body>
  <!-- 왼쪽 메뉴 -->
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
  
  <h2>공지사항 작성</h2>
 <div class="notice-content" >
  <form method="post" action="${pageContext.request.contextPath}/notice/insertNotice">

    <!-- 관리자 아이디 표시 (readonly) -->
    <div class="form-group">
      <label>작성자</label>
      <input type="text" class="form-control" value="${loginUser.adminId}" readonly>
      <input type="hidden" name="adminId" value="${loginUser.adminId}">
    </div>

    <!-- 제목 입력 -->
    <div class="form-group">
      <input type="text" name="title" class="form-control" placeholder="제목을 입력해주세요.">
    </div>

    <!-- 내용 입력 -->
    <div class="form-group">
      <textarea name="content" rows="10" class="form-control" placeholder="내용을 입력해주세요."></textarea>
    </div>

    <!-- 등록 버튼 -->
    <div class="form-group">
      <button type="submit" class="btn-submit">등록</button>
    </div>
    
    <!-- 돌아가기 버튼 -->
    <div class="form-group">
      <a href="${pageContext.request.contextPath}/notice/noticeList" class="btn-submit">돌아가기</a>
    </div>

  </form>
 </div>
</body>
</html>