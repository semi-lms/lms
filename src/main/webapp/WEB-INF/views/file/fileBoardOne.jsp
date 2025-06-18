<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>			
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>	<!-- 날짜 포맷 태그 -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>자료실 상세보기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/fileBoard.css">	<!-- 외부 CSS 적용 -->
</head>
<body>
<fmt:setTimeZone value="Asia/Seoul" />	<!-- 시간대를 한국 시간으로 설정 -->
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
      <th>번호</th>
      <td>${fileBoard.fileBoardNo}</td>
    </tr>
    <tr>
      <th>작성자</th>
		<!-- 작성자 admin이면 '관리자'로 출력 -->
		    <!--
		    <form method="get" action="${pageContext.request.contextPath}/file/downloadAll">
              <input type="hidden" name="fileBoardNo" value="${fileBoard.fileBoardNo}">
             <-- <button type="submit">전체 다운로드(추후구현?)</button>
            </form>
             -->
		<td>
			<c:choose>
				<c:when test="${fileBoard.adminId eq 'admin'}">관리자</c:when>
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
      <td style="white-space: pre-wrap;">${fileBoard.content}</td>	<!-- 줄바꿈 유지 -->
    </tr>
    <tr>
      <th>파일</th>
  <td>
     <c:choose>
      <c:when test="${not empty fileList}">
        <c:forEach var="file" items="${fileList}">
  <c:choose>
    <c:when test="${file.fileType.startsWith('image/')}">
    <!-- 이미지 있을 경우 미리보기  -->
      <div class="file-preview-wrapper">
        <span class="file-name">📎 ${file.fileName}</span>
        <div class="img-preview">
          <img src="data:${file.fileType};base64,${file.base64Data}" alt="미리보기" />
        </div>
        <a class="download-link"
           href="data:${file.fileType};base64,${file.base64Data}"
           download="${file.fileName}">
          ⬇️ 다운로드
        </a>
      </div>
    </c:when>
    <c:otherwise>
      <!-- 이미지 아닌 파일인 경우 미리보기 없이 파일명과 다운로드 링크-->
      <div class="file-preview-wrapper">
        <span class="file-name">📎 ${file.fileName}</span>
        <a class="download-link"
           href="data:${file.fileType};base64,${file.base64Data}"
           download="${file.fileName}">
          ⬇️ 다운로드
        </a>
      </div>
    </c:otherwise>
  </c:choose>
</c:forEach>
      </c:when>
      <c:otherwise>
        (첨부된 파일 없음)
      </c:otherwise>
    </c:choose>
  </td>
</tr>
    <tr>
      <th>작성일</th>
      <td><fmt:formatDate value="${fileBoard.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
    </tr>
  </table>

  <br>
	<!-- 관리자만 수정/삭제 버튼 표시 -->
  <c:if test="${loginUser.role eq 'admin'}">
  <div class="btn-group">
    <form method="get" action="${pageContext.request.contextPath}/file/updateFileBoard">
      <input type="hidden" name="fileBoardNo" value="${fileBoard.fileBoardNo}">
      <button type="submit" class="btn-submit">수정</button>
    </form>

    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/file/deletefileBoard">
      <input type="hidden" name="fileBoardNo" value="${fileBoard.fileBoardNo}">
      <input type="hidden" name="pw" id="pw">
      <button type="button" onclick="handleDelete()" class="btn-submit">삭제</button>
    </form>

</c:if>


  <br>
  <a href="${pageContext.request.contextPath}/file/fileBoardList"><button>목록으로</button></a>
    </div>
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