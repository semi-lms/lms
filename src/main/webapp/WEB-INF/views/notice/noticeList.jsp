<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>공지사항 리스트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
</head>
<body>
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/${loginUser.role}SideBar.jsp" />
  </div>
  <div class="main-content">
  <h1>공지사항</h1>

  <!-- 검색 영역 -->
  <div class="notice-search">
    <form method="get">
      <select name="searchOption">
        <option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
        <option value="title" ${searchOption == 'title' ? 'selected' : ''}>제목</option>
      </select>
      <input type="text" name="keyword" value="${searchNotice}" placeholder="검색">
      <button type="submit">검색</button>
    </form>
  </div>

  <!-- 공지사항 테이블 -->
  <table class="notice-table">
    <tr>
      <th>번호</th>
      <th>제목</th>
      <th>작성자</th>
      <th>작성일</th>
    </tr>
    <c:forEach var="notice" items="${noticeList}">
      <tr>
        <td>${notice.noticeId}</td>
        <td><a href="/notice/noticeOne?noticeId=${notice.noticeId}">${notice.title}</a></td>
        <td>
          <c:choose>
            <c:when test="${notice.adminId eq 'admin'}">관리자</c:when>
            <c:otherwise>${notice.adminId}</c:otherwise>
          </c:choose>
        </td>
        <td>${notice.createDate}</td>
      </tr>
    </c:forEach>
  </table>

  <!-- 작성 버튼 -->
		<div class="button-group">

    <c:if test="${loginUser.role eq 'admin'}">
      <a href="/notice/insertNotice"><button type="button">작성</button></a>
    </c:if>
  </div>

  <!-- 페이징 -->
  <div class="pagination">
    <!-- (생략: 기존 코드 그대로 유지) -->
  </div>
</div>
</html>
