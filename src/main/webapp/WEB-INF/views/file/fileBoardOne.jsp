<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>자료실 상세보기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/fileBoard.css">
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
<div class="fileBoard-content">
  <h2>자료실 상세보기</h2>

  <table border="1" cellpadding="10">
    <tr>
      <th>작성자</th>
		<!-- 작성자 admin이면 '관리자'로 출력 -->
		<td>
			<c:choose>
				<c:when test="${fileBoard.adminId eq 'admin'}">김예진/노민혁</c:when>
				<c:otherwise>${fileBoard.adminId}</c:otherwise>
			</c:choose>
		</td>
    </tr>
    <tr>
      <th>제목</th>
      <td>${fileBoard.title}</td>
    </tr>
    <tr>
      <th>내용</th>
      <td style="white-space: pre-wrap;">${fileBoard.content}</td>
    </tr>
    <tr>
      <th>작성일</th>
      <td>${fileBoard.createDate}</td>
    </tr>
  </table>

  <br>

  <c:if test="${loginUser.role eq 'admin'}">
    <!-- 관리자만 수정/삭제 가능 -->
    <form method="get" action="${pageContext.request.contextPath}/file/updateFileBoard">
      <input type="hidden" name="fileBoardNo" value="${fileBoard.fileBoardNo}">
      <button type="submit">수정</button>
    </form>

    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/file/deletefileBoard">
      <input type="hidden" name="fileBoardNo" value="${fileBoard.fileBoardNo}">
      <!-- 삭제할경우 비밀번호 입력 -->
      <input type="hidden" name="pw" id="pw"> <!-- JS에서 값 넣을 자리 -->
      <button type="button" onclick="handleDelete()">삭제</button>
      
    </form>
  </c:if>

  <br>
  <a href="${pageContext.request.contextPath}/file/fileBoardList"><button>목록으로</button></a>
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