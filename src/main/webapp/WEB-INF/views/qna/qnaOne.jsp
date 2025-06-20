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
<div class="main-content">
  <h2>qna 상세보기</h2>

  <table class="qna-table">
    <tr><th>작성자</th><td>${qna.studentName}</td></tr>
    <tr><th>제목</th><td>${qna.title}</td></tr>
    <tr><th>내용</th><td style="white-space: pre-wrap;">${qna.content}</td></tr>
    <tr><th>작성일</th><td><fmt:formatDate value="${qna.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td></tr>
  </table>

  <br>

  <!-- 수정/삭제 버튼 영역 -->
  <c:if test="${loginUser.role eq 'student' && loginUser.studentNo eq qna.studentNo && commentCount eq 0}">
    <div class="comment-action-right">
      <form method="get" action="${pageContext.request.contextPath}/qna/updateQna" onsubmit="saveScrollAndSubmit(this)">
        <input type="hidden" name="qnaId" value="${qna.qnaId}">
        <button type="submit">수정</button>
      </form>
      <form id="studentDeleteForm" method="post" action="${pageContext.request.contextPath}/qna/deleteQna" onsubmit="saveScrollAndSubmit(this)">
        <input type="hidden" name="qnaId" value="${qna.qnaId}">
        <input type="hidden" name="pw" id="pw">
        <button type="button" onclick="handleDelete()">삭제</button>
      </form>
    </div>
  </c:if>

  <c:if test="${loginUser.role eq 'admin'}">
    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/qna/deleteQna" onsubmit="saveScrollAndSubmit(this)" class="comment-action-right">
      <input type="hidden" name="qnaId" value="${qna.qnaId}">
      <input type="hidden" name="pw" id="pw">
      <button type="button" onclick="handleDelete()">삭제</button>
    </form>
  </c:if>

  <!-- 댓글 및 대댓글 영역 -->
  <hr>
  <h4>💬 답변</h4>
  <c:forEach var="comment" items="${commentList}">
    <c:if test="${comment.parentCommentId == null}">
      <div class="qna-comment-wrapper">
      <div class="comment-row">
        <!--  작성자 -->
        <p><strong>${comment.writerId}</strong> (${comment.writerRole}) <fmt:formatDate value="${comment.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
        
         <!-- 수정/삭제 -->
         <!-- 관리자는 모든 댓글 삭제 가능 -->
          <div class="comment-action-right">
			 <c:choose>
			    <%-- 1. 본인 글이면: 수정 + 삭제 --%>
			    <c:when test="${comment.writerId eq loginUserId}">
			      <!-- 수정 버튼 -->
			      <form method="get" action="${pageContext.request.contextPath}/qna/qnaOne#comment-${comment.commentId}" onsubmit="saveScrollAndSubmit(this)" style="display:inline;">
			        <input type="hidden" name="qnaId" value="${qna.qnaId}">
			        <input type="hidden" name="editCommentId" value="${comment.commentId}">
			        <button type="submit">수정</button>
			      </form>
			      <!-- 삭제 버튼 -->
			      <form method="post" action="${pageContext.request.contextPath}/qna/deleteQnaComment" onsubmit="saveScrollAndSubmit(this)" style="display:inline;">
			        <input type="hidden" name="commentId" value="${comment.commentId}">
			        <input type="hidden" name="qnaId" value="${qna.qnaId}">
			        <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
			      </form>
			    </c:when>
			
			    <%-- 2. 관리자면서 본인이 작성한 글이 아닌 경우: 삭제만 --%>
			    <c:when test="${loginUser.role eq 'admin'}">
			      <form method="post" action="${pageContext.request.contextPath}/qna/deleteQnaComment" onsubmit="saveScrollAndSubmit(this)" style="display:inline;">
			        <input type="hidden" name="commentId" value="${comment.commentId}">
			        <input type="hidden" name="qnaId" value="${qna.qnaId}">
			        <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
			      </form>
			    </c:when>
			  </c:choose>
          </div>
         </div> 

        <!-- 댓글 내용만 박스 -->
        <div id="comment-${comment.commentId}" class="comment-content-box comment-row">
          <c:if test="${editCommentId == null or editCommentId != comment.commentId}">
          <div class="comment-text">${comment.content}</div>
          </c:if>
          <c:if test="${editCommentId eq comment.commentId}">
            <form method="post" action="${pageContext.request.contextPath}/qna/updateQnaComment" onsubmit="saveScrollAndSubmit(this)">
              <input type="hidden" name="commentId" value="${comment.commentId}">
              <input type="hidden" name="qnaId" value="${qna.qnaId}">
              <textarea name="content" rows="3" cols="60" onfocus="clearOnFirstFocus(this)">${comment.content}</textarea><br>
              <button type="submit">저장</button>
              <a href="${pageContext.request.contextPath}/qna/qnaOne?qnaId=${qna.qnaId}">취소</a>
            </form>
          </c:if>
        </div>
        
        <!-- 대댓글 출력 -->
        <c:forEach var="reply" items="${commentList}">
          <c:if test="${reply.parentCommentId == comment.commentId}">
            <div class="reply-box">
              <!-- 작성자/날짜 + 수정/삭제 버튼을 flex로 나눔 -->
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>↳ <strong>${reply.writerId}</strong> (${reply.writerRole}) <fmt:formatDate value="${reply.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
                
				<c:choose>
				 <%-- 본인이 작성한 대댓글인 경우: 수정/삭제 가능 --%>
				  <c:when test="${reply.writerId eq loginUserId}">
				    <div>
				      <form method="get"
				            action="${pageContext.request.contextPath}/qna/qnaOne#comment-${reply.commentId}"
				            onsubmit="saveScrollAndSubmit(this)" style="display:inline;">
				        <input type="hidden" name="qnaId" value="${qna.qnaId}">
				        <input type="hidden" name="editCommentId" value="${reply.commentId}">
				        <button type="submit">수정</button>
				      </form>
				
				      <form method="post" action="${pageContext.request.contextPath}/qna/deleteQnaComment"
				            onsubmit="saveScrollAndSubmit(this)" style="display:inline;">
				        <input type="hidden" name="commentId" value="${reply.commentId}">
				        <input type="hidden" name="qnaId" value="${qna.qnaId}">
				        <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
				      </form>
				    </div>
				  </c:when>
				
				  <%-- 관리자일 경우: 모든 대댓글 삭제 가능 --%>
				  <c:when test="${loginUser.role eq 'admin'}">
				    <div>
				      <form method="post" action="${pageContext.request.contextPath}/qna/deleteQnaComment"
				            onsubmit="saveScrollAndSubmit(this)" style="display:inline;">
				        <input type="hidden" name="commentId" value="${reply.commentId}">
				        <input type="hidden" name="qnaId" value="${qna.qnaId}">
				        <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
				      </form>
				    </div>
				  </c:when>
				</c:choose>
              </div>
              
              <!-- 내용 or 수정폼 -->
              <div style="margin-top: 5px;">
                <c:if test="${editCommentId != reply.commentId}">${reply.content}</c:if>
                <c:if test="${editCommentId == reply.commentId}">
                  <form method="post" action="${pageContext.request.contextPath}/qna/updateQnaComment" onsubmit="saveScrollAndSubmit(this)">
                    <input type="hidden" name="commentId" value="${reply.commentId}">
                    <input type="hidden" name="qnaId" value="${qna.qnaId}">
                    <textarea name="content" rows="3" cols="50" onfocus="clearOnFirstFocus(this)">${reply.content}</textarea><br>
                    <button type="submit">저장</button>
                    <a href="${pageContext.request.contextPath}/qna/qnaOne?qnaId=${qna.qnaId}">취소</a>
                  </form>
                </c:if>
              </div>
            </div>
          </c:if>
        </c:forEach>
<!-- 대댓글 입력 토글 버튼 -->
<p id="replyToggle-${comment.commentId}" style="cursor: pointer; color: blue; display: inline;"
   onclick="showReplyForm(${comment.commentId})">댓글쓰기</p>
        <!-- 대댓글 입력 폼 -->
        <div  id="replyForm-${comment.commentId}" class="reply-form" style="display: none;">
          <form method="post" action="${pageContext.request.contextPath}/qna/insertQnaComment" onsubmit="saveScrollAndSubmit(this)">
            <input type="hidden" name="qnaId" value="${qna.qnaId}">
            <input type="hidden" name="parentCommentId" value="${comment.commentId}">
            <input type="text" name="content" placeholder="답글 작성" style="width: 300px;">
            <button type="submit">등록</button>
             <button type="button" onclick="cancelReplyForm(${comment.commentId})">취소</button>
          </form>
        </div>
      </div>
    </c:if>
  </c:forEach>

  <!-- 일반 댓글 입력 폼 -->
  <c:if test="${not empty loginUser && loginUser.role ne 'student'}">
    <form method="post" action="${pageContext.request.contextPath}/qna/insertQnaComment" onsubmit="saveScrollAndSubmit(this)">
      <input type="hidden" name="qnaId" value="${qna.qnaId}">
      <textarea name="content" rows="4" cols="60" placeholder="댓글을 입력하세요" required></textarea><br>
      <button type="submit">댓글 등록</button>
    </form>
  </c:if>

  <br>
  <div class="button-group">
   <a href="${pageContext.request.contextPath}/qna/qnaList"><button>목록으로</button></a>
  </div>
</div>
	<script>
	 function showReplyForm(commentId) {
		    // 댓글쓰기 텍스트 숨기고, 폼 보여주기
		    document.getElementById("replyToggle-" + commentId).style.display = "none";
		    document.getElementById("replyForm-" + commentId).style.display = "block";
		  }
	 		// 취소버튼 누르면 돌아가기
	  function cancelReplyForm(commentId) {
		    document.getElementById("replyForm-" + commentId).style.display = "none";
		    document.getElementById("replyToggle-" + commentId).style.display = "inline";
		  }
	
		function handleDelete() {
			// alert("삭제 버튼 클릭됨");  // 디버깅용
		  if (confirm("정말로 삭제하시겠습니까?")) {
		    const pw = prompt("비밀번호를 입력하세요");
		    
		    if (pw === null || pw.trim() === "") {
		      alert("비밀번호를 입력해주세요");
		      return;
		    }
		
		    document.getElementById("pw").value = pw; // hidden input에 비번 저장
		    // 로그인한 사용자의 role에 따라 올바른 form 선택
		    const loginUserRole = "${loginUser.role}"; // JSP에서 전달

		    if (loginUserRole === "admin") {
		      document.getElementById("deleteForm").submit();
		    } else {
		      document.getElementById("studentDeleteForm").submit();
		    }
		  }
		}
		// 내용칸 클릭하면 기존 글 삭제
		 function clearOnFirstFocus(el) {
			    // 한 번만 비우도록 체크
			    if (!el.dataset.cleared) {
			      el.dataset.cleared = "true";
			      el.value = "";
			    }
			  }
		
		// 현재 스크롤 위치 저장한 후 폼 제출 (페이지 새로고침 시 해당 위치 유지)
		  function saveScrollAndSubmit(form) {
			    // 스크롤 위치 저장
			    sessionStorage.setItem("scrollY", window.scrollY);

			    // 약간의 지연을 주고 수동으로 submit
			    setTimeout(() => {
			      form.submit();
			    }, 0);

			    // 기본 submit 방지
			    return false;
			  }
		  
		  // 페이지 로드 시 이전에 저장된 스크롤 위치로 이동
		  window.addEventListener("load", () => {				
			    const y = sessionStorage.getItem("scrollY");	// 저장된 위치 꺼냄
			    if (y !== null) {
			      window.scrollTo(0, parseInt(y));				// 스크롤 이동
			      sessionStorage.removeItem("scrollY");			// 사용 후 제거
			    }
			  });
	</script>
</body>
</html>