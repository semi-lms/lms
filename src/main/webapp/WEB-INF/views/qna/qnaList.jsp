<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<meta charset="UTF-8">
<title>qna 리스트</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/qna.css">
</head>
<body>
<fmt:setTimeZone value="Asia/Seoul" />
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
	  <div class="qna-content" >
		<h1>qna</h1>
		<form method="get" > 
			<table border="1">
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>답변</th>
					<th>작성일</th>
				</tr>
				<c:forEach var="qna" items="${qnaList}">
					<tr>
						<td>${qna.qnaId}</td>
						<td>
					      <c:choose>
				        <c:when test="${qna.isSecret eq 'Y'}">
				        <!-- 비밀글인 경우 -->
				          <a href="#" onclick="handleSecretQna(${qna.qnaId}, '${loginUser.role}')">🔒 ${qna.title}</a>
				        </c:when>
						    <c:otherwise>
						    <!--  공개글 -->
						      <a href="/qna/qnaOne?qnaId=${qna.qnaId}">${qna.title}</a>
						    </c:otherwise>
						  </c:choose>
						</td>
						<td>${qna.studentName}</td>
						<td>${qna.answerStatus}</td>
						<td><fmt:formatDate value="${qna.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					</tr>
				</c:forEach>
			</table>
			<br>
				<c:if test="${loginUser.role eq 'student'}">
				   <a href="/qna/insertQna"><button type="button">작성</button></a><br>
				</c:if>
			 	<select name="searchOption" id="searchOption">
				<option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
				<option value="title"
					${searchOption == 'title' ? 'selected' : ''}>제목</option>
				<option value="studentNo"
					${searchOption == 'studentNo' ? 'selected' : ''}>작성자</option>
				</select> <input type="text" name="keyword" id="searchQna"
					value="${searchQna}" placeholder="검색">
				<button type="submit" id="searchBtn">검색</button>
		 </form>
		 	<c:if test="${page.lastPage > 1 }">
				<c:if test="${startPage > 1 }">
					<a
						href="/qna/qnaList?currentPage=${startPage - 1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&searchQna=${searchQna}">[이전]</a>
				</c:if>
			</c:if>
			<c:forEach var="i" begin="${startPage}" end="${endPage}">
				<c:choose>
					<c:when test="${i == page.currentPage }">
						<span>[${i}]</span>
					</c:when>
					<c:otherwise>
						<a
							href="/qna/qnaList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&searchQna=${searchQna}">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${endPage < page.lastPage }">
				<a
					href="/qna/qnaList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&searchQna=${searchQna}">[다음]</a>
			</c:if>
		</div>
	</div>
	<c:if test="${not empty errorMsg}">
		<script>
		    alert("${errorMsg}");
		</script>
	</c:if>
	<script>
		function handleSecretQna(qnaId, role) {
		  if (role === 'student') {
		    const pw = prompt('비밀글입니다. 비밀번호를 입력하세요:');
		    if (pw && pw.trim() !== '') {
		      // 비밀번호와 함께 form 제출 or 파라미터 넘기기
		      const form = document.createElement('form');
		      form.method = 'post';
		      form.action = '/qna/qnaOne';
		
		      const qnaInput = document.createElement('input');
		      qnaInput.type = 'hidden';
		      qnaInput.name = 'qnaId';
		      qnaInput.value = qnaId;
		      form.appendChild(qnaInput);
		
		      const pwInput = document.createElement('input');
		      pwInput.type = 'hidden';
		      pwInput.name = 'pw';
		      pwInput.value = pw;
		      form.appendChild(pwInput);
		
		      document.body.appendChild(form);
		      form.submit();
		    } else {
		      alert('비밀번호를 입력해주세요.');
		    }
		  } else {
		    // 관리자 또는 강사 → 그냥 이동
		    location.href = '/qna/qnaOne?qnaId=' + qnaId;
		  }
		}
	</script>
</body>
</html>