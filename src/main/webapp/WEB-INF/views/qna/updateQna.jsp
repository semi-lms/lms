<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>공지사항 수정</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/qna.css">
</head>
<body>

<!-- 사이드바 -->
<div class="sidebar">
  <c:choose>
    <c:when test="${loginUser.role eq 'student'}">
      <jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
    </c:when>
  </c:choose>
</div>

<!-- 본문 -->
<div class="notice-content">
  <h2>공지사항 수정</h2>

  <form method="post" action="${pageContext.request.contextPath}/qna/updateQna">
    
    <!-- 숨겨진 공지 ID -->
    <input type="hidden" name="noticeId" value="${qna.qnaId}">
	<div class="form-group">
      <label>작성자</label>
      <input type="text" name="noticeId" value="${qna.studentName}" class="form-control" readonly>
    </div>
    <!-- 제목 -->
    <div class="form-group">
      <label for="title">제목</label>
      <input type="text" name="title" value="${qna.title}" class="form-control">
    </div>

    <!-- 내용 -->
	<div class="form-group">
	  <label for="content">내용</label>
	  <textarea id="content" name="content" rows="10" cols="50">${qna.content}</textarea>
	</div>

    <!-- 수정 버튼 -->
    <div class="form-group">
      <button type="submit" class="btn-submit">수정 완료</button>
    </div>

    <!-- 뒤로가기 -->
    <div class="form-group">
      <a href="${pageContext.request.contextPath}/qna/qnaOne?noticeId=${qna.qnaId}">
        <button type="button" class="btn-submit">돌아가기</button>
      </a>
    </div>

  </form>
</div>

</body>
</html>