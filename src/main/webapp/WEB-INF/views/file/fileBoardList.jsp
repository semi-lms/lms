<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<meta charset="UTF-8">
<title>자료실 리스트</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/fileBoard.css">
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
	  <div class="fileBoard-content" >
		<h1>자료실</h1>
		<form method="get">
  <div class="fileBoard-top-bar">
    <c:if test="${loginUser.role eq 'admin'}">
      <a href="/file/insertFileBoard"><button type="button">작성</button></a>
    </c:if>

    <div class="search-group">
      <select name="searchOption" id="searchOption">
        <option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
        <option value="title" ${searchOption == 'title' ? 'selected' : ''}>제목</option>
      </select>
      <input type="text" name="keyword" id="searchOption" value="${searchFileBoard}" placeholder="검색">
      <button type="submit" id="searchBtn">검색</button>
    </div>
  </div>

  <table>
    <tr>
      <th>번호</th>
      <th>제목</th>
      <th>작성자</th>
      <th>작성일</th>
    </tr>
    <c:forEach var="fileBoard" items="${fileBoardList}">
      <tr>
        <td>${fileBoard.fileBoardNo}</td>
        <td><a href="/file/fileBoardOne?fileBoardNo=${fileBoard.fileBoardNo}">${fileBoard.title}</a></td>
        <td>
          <c:choose>
            <c:when test="${fileBoard.adminId eq 'admin'}">김예진/노민혁</c:when>
            <c:otherwise>${fileBoard.adminId}</c:otherwise>
          </c:choose>
        </td>
        <td><fmt:formatDate value="${fileBoard.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
      </tr>
    </c:forEach>
  </table>
</form>
		 	<c:if test="${page.lastPage > 1 }">
				<c:if test="${startPage > 1 }">
					<a
						href="/file/fileBoardList?currentPage=${startPage - 1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&searchFileBoard=${searchFileBoard}">[이전]</a>
				</c:if>
			</c:if>
			<c:forEach var="i" begin="${startPage}" end="${endPage}">
				<c:choose>
					<c:when test="${i == page.currentPage }">
						<span>[${i}]</span>
					</c:when>
					<c:otherwise>
						<a
							href="/file/fileBoardList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&searchFileBoard=${searchFileBoard}">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${endPage < page.lastPage }">
				<a
					href="/file/fileBoardList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&searchFileBoard=${searchFileBoard}">[다음]</a>
			</c:if>
		</div>
	</div>
</body>
</html>