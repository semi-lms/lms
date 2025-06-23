<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>자료실 수정</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/fileBoard.css">
</head>
<body>

<!-- 사이드바 -->
<div class="sidebar">
  <c:choose>
    <c:when test="${loginUser.role eq 'admin'}">
      <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
    </c:when>
  </c:choose>
</div>

<!-- 본문 -->
<div class="fileBoard-content">
  <h2>자료실 수정</h2>

  <form method="post" 
  		action="${pageContext.request.contextPath}/file/updateFileBoard"
  		enctype="multipart/form-data"
  		onsubmit="return validateForm()">
    
    <!-- 숨겨진 공지 ID -->
    <input type="hidden" name="fileBoardNo" value="${fileBoard.fileBoardNo}">
	<div class="form-group">
      <label>작성자</label>
      <input type="text" value="관리자" class="form-control" readonly>
    </div>
    <!-- 제목 -->
    <div class="form-group">
      <label for="title">제목</label>
      <input type="text" id="title" name="title" value="${fileBoard.title}" class="form-control" placeholder="제목을 입력해주세요.">
    </div>

    <!-- 내용 -->
	<div class="form-group">
	  <label for="content">내용</label>
	  <textarea id="content" name="content" rows="10" cols="50" placeholder="내용을 입력해주세요.">${fileBoard.content}</textarea>
	</div>
	
	<!-- 기존 첨부파일 -->
<c:forEach var="file" items="${fileList}">
  <div>
	 <a href="${pageContext.request.contextPath}/file/download?fileName=${file.saveName}" download="${file.fileName}">
	  ${file.fileName}
	</a>
    <label>
      <input type="checkbox" name="deleteFileIds" value="${file.fileId}">
      삭제
    </label>
  </div>
</c:forEach>
	
	  <!-- 새로운 파일 추가 -->
	  <div>
	    새로운 첨부파일 추가
	    <input type="file" name="uploadFile" multiple>
	    <small>※ Ctrl(또는 Shift)를 누른 채 여러 개의 파일을 한 번에 선택하세요.</small>
	  </div>
	<br>

    <!-- 수정 버튼 -->
    <div class="btn-group">
    <div class="form-group">
      <button type="submit" class="btn-submit">수정 완료</button>
    </div>

    <!-- 뒤로가기 -->
    <div class="form-group">
      <a href="${pageContext.request.contextPath}/file/fileBoardOne?fileBoardNo=${fileBoard.fileBoardNo}">
        <button type="button" class="btn-submit">돌아가기</button>
      </a>
    </div>
</div>
  </form>
</div>
 <!-- 제목 내용을 입력하지 않을경우 -->
  <script>
	function validateForm() {
	  const title = document.getElementById("title").value.trim();
	  const content = document.getElementById("content").value.trim();
	
	  if (title === "" || content === "") {
	    alert("제목과 내용을 입력해주세요");
	    return false; // 제출 막음
	  }
	
	  return true; // 정상 제출
	}
	
	   function setupAutoClearRestore(id, originalValue) {
	        const input = document.getElementById(id);
	        let cleared = false;

	        input.addEventListener("focus", function () {
	          if (!cleared && input.value === originalValue) {
	            input.value = "";
	            cleared = true;
	          }
	        });

	        input.addEventListener("blur", function () {
	          if (input.value.trim() === "") {
	            input.value = originalValue;
	            cleared = false;
	          }
	        });
	      }

	      window.addEventListener("DOMContentLoaded", function () {
	        // 제목 필드에 동작 연결
	        setupAutoClearRestore("title", "${fn:escapeXml(fileBoard.title)}");

	        // 내용 필드에 동작 연결 (textarea)
	        setupAutoClearRestore("content", "${fn:escapeXml(fileBoard.content)}");
	      });
	</script>
</body>
</html>