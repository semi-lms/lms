<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<meta charset="UTF-8">
<title>qna 리스트</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/qna.css">
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
	  <div class="notice-content" >
		<h1>qna</h1>
		<form method="get" > 
			<table border="1">
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
				</tr>
				<c:forEach var="qna" items="${qnaList}">
					<tr>
						<td>${qna.qnaId}</td>
						<td><a href="/qna/qnaOne?qnaId=${qna.qnaId}">${qna.title} </a></td>
						<td>${qna.studentName}</td>
						<td>${qna.createDate}</td>
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
</body>
</html>