<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>공지사항 상세보기</title>
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

  <!-- 본문 -->
  <div class="main-content">
    <div class="notice-content">
      <h2>공지사항 상세보기</h2>

      <table border="1" cellpadding="10" style="width:100%;">
        <tr>
          <th>작성자</th>
          <td>
            <c:choose>
              <c:when test="${notice.adminId eq 'admin'}">관리자</c:when>
              <c:otherwise>${notice.adminId}</c:otherwise>
            </c:choose>
          </td>
        </tr>
        <tr>
          <th>제목</th>
          <td>${notice.title}</td>
        </tr>
        <tr>
          <th>내용</th>
          <td style="white-space: pre-wrap;">${notice.content}</td>
        </tr>
        <tr>
          <th>작성일</th>
          <td>${notice.createDate}</td>
        </tr>
      </table>

      <br>
		<div class="button-group">
      <c:if test="${loginUser.role eq 'admin'}">
        <form method="get" action="${pageContext.request.contextPath}/notice/updateNotice" style="display:inline-block;">
          <input type="hidden" name="noticeId" value="${notice.noticeId}">
          <button type="submit">수정</button>
        </form>

        <form method="post" action="${pageContext.request.contextPath}/notice/deleteNotice" style="display:inline-block; margin-left:10px;">
          <input type="hidden" name="noticeId" value="${notice.noticeId}">
          <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
        </form>
      </c:if>

      <br><br>
      
     <form action="${pageContext.request.contextPath}/notice/noticeList" method="get" style="display:inline-block;">
  <button type="submit" class="btn-submit">목록으로</button>
</form>
</div>
    </div>
  </div>

</body>
</html>
