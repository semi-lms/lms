<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>qna 상세보기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/qna.css">
</head>
<body>

<!-- 사이드바 -->
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
<div class="notice-content">
  <h2>공지사항 상세보기</h2>

  <table border="1" cellpadding="10">
    <tr>
      <th>작성자</th>
      <td>${qna.studentName}</td>
    </tr>
    <tr>
      <th>제목</th>
      <td>${qna.title}</td>
    </tr>
    <tr>
      <th>내용</th>
      <td style="white-space: pre-wrap;">${qna.content}</td>
    </tr>
    <tr>
      <th>작성일</th>
      <td>${qna.createDate}</td>
    </tr>
  </table>

  <br>

<!-- 학생인 경우: 수정 + 삭제 버튼 나란히 -->
<c:if test="${loginUser.role eq 'student' && loginUser.studentNo eq qna.studentNo}">
  <div style="display: flex; gap: 10px;">
    <!-- 수정 버튼 -->
    <form method="get" action="${pageContext.request.contextPath}/qna/updateQna">
      <input type="hidden" name="qnaId" value="${qna.qnaId}">
      <button type="submit">수정</button>
    </form>

    <!-- 삭제 버튼 -->
    <form method="post" action="${pageContext.request.contextPath}/qna/deleteQna">
      <input type="hidden" name="qnaId" value="${qna.qnaId}">
      <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
    </form>
  </div>
</c:if>

<!-- 관리자일 경우: 삭제만 가능 -->
<c:if test="${loginUser.role eq 'admin'}">
  <form method="post" action="${pageContext.request.contextPath}/qna/deleteQna">
    <input type="hidden" name="qnaId" value="${qna.qnaId}">
    <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
  </form>
</c:if>
 

  <br>
  <a href="${pageContext.request.contextPath}/qna/qnaList"><button>목록으로</button></a>
</div>

</body>
</html>