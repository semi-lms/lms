<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>qna 상세보기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/qna.css">
</head>
<body>
<fmt:setTimeZone value="Asia/Seoul" />
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
<div class="qna-content">
  <h2>qna 상세보기</h2>

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
      <td><fmt:formatDate value="${qna.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
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
    <form id="studentDeleteForm" method="post" action="${pageContext.request.contextPath}/qna/deleteQna">
      <input type="hidden" name="qnaId" value="${qna.qnaId}">
      <!-- 삭제할경우 비밀번호 입력 -->
      <input type="hidden" name="pw" id="pw"> <!-- JS에서 값 넣을 자리 -->
      <button type="button" onclick="handleDelete()">삭제</button>
    </form>
  </div>
</c:if>

<!-- 관리자일 경우: 삭제만 가능 -->
<c:if test="${loginUser.role eq 'admin'}">
  <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/qna/deleteQna">
    <input type="hidden" name="qnaId" value="${qna.qnaId}">
      <!-- 삭제할경우 비밀번호 입력 -->
      <input type="hidden" name="pw" id="pw"> <!-- JS에서 값 넣을 자리 -->
      <button type="button" onclick="handleDelete()">삭제</button>
  </form>
</c:if>

<!-- ✨ QnA 답변 댓글 영역 -->
<hr>
<h4>💬 답변</h4>
 <!-- 댓글 목록 -->
<c:forEach var="comment" items="${commentList}">
  <div id="comment-${comment.commentId}">
    <p><strong>${comment.writerId} (${comment.writerRole})</strong> | <fmt:formatDate value="${comment.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></p>

    <!-- 댓글 내용 표시 -->
    <c:if test="${editCommentId == null or editCommentId != comment.commentId}">
      <div class="comment-box">${comment.content}</div>
    </c:if>

    <!-- 수정 중인 댓글일 경우 -->
    <c:if test="${editCommentId eq comment.commentId}">
      <form method="post" action="${pageContext.request.contextPath}/qna/updateQnaComment">
        <input type="hidden" name="commentId" value="${comment.commentId}">
        <input type="hidden" name="qnaId" value="${qna.qnaId}">
        <textarea name="content" rows="3" cols="60">${comment.content}</textarea><br>
        <button type="submit">저장</button>
        <a href="${pageContext.request.contextPath}/qna/qnaOne?qnaId=${qna.qnaId}">취소</a>
      </form>
    </c:if>

    <!-- 수정/삭제 버튼 -->
    <c:choose>
      <c:when test="${loginUser.role eq 'admin' || loginUser.role eq 'teacher'}">
        <form method="post" action="${pageContext.request.contextPath}/qna/deleteQnaComment" style="display:inline;">
          <input type="hidden" name="commentId" value="${comment.commentId}">
          <input type="hidden" name="qnaId" value="${qna.qnaId}">
          <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
        </form>
      </c:when>

      <c:when test="${loginUser.role eq comment.writerRole && loginUser.studentId eq comment.writerId}">
        <form method="get" action="${pageContext.request.contextPath}/qna/qnaOne">
          <input type="hidden" name="qnaId" value="${qna.qnaId}">
          <input type="hidden" name="editCommentId" value="${comment.commentId}">
          <button type="submit">수정</button>
        </form>
        
        <form method="post" action="${pageContext.request.contextPath}/qna/deleteQnaComment" style="display:inline;">
          <input type="hidden" name="commentId" value="${comment.commentId}">
          <input type="hidden" name="qnaId" value="${qna.qnaId}">
          <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
        </form>
      </c:when>
    </c:choose>
  </div>
</c:forEach>

<!-- 댓글 작성 폼 (작성자 본인, 강사, 관리자만) -->
<c:if test="${loginUser.role eq 'admin' 
           || loginUser.role eq 'teacher' 
           || loginUser.studentNo eq qna.studentNo}">
  <form action="${pageContext.request.contextPath}/qna/insertQnaComment" method="post">
    <input type="hidden" name="qnaId" value="${qna.qnaId}">
    <textarea name="content" rows="4" cols="60" placeholder="답변을 입력하세요" required></textarea><br>
    <button type="submit">답변 등록</button>
  </form>
</c:if>

  <br>
  <a href="${pageContext.request.contextPath}/qna/qnaList"><button>목록으로</button></a>
</div>
	<script>
		function handleDelete() {
			// alert("삭제 버튼 클릭됨");  // 디버깅용
		  if (confirm("정말로 삭제하시겠습니까?")) {
		    const pw = prompt("비밀번호를 입력하세요");
		    
		    if (pw === null || pw.trim() === "") {
		      alert("비밀번호를 입력해주세요");
		      return;
		    }
		
		    document.getElementById("pw").value = pw; // hidden input에 비번 저장
		    document.getElementById("deleteForm").submit(); // 폼 제출
		  }
		}
		
	</script>
</body>
</html>