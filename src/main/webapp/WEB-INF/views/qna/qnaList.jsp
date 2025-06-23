<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Q&A 리스트</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/qna.css">
</head>
<body>
  <fmt:setTimeZone value="Asia/Seoul" />

  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/${loginUser.role}SideBar.jsp" />
  </div>

  <div class="main-content">
    <h1>Q&A</h1>

    <!-- 검색 영역 -->
    <div class="qna-search">
      <form method="get">
        <select name="searchOption">
          <option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
          <option value="title" ${searchOption == 'title' ? 'selected' : ''}>제목</option>
          <option value="studentNo" ${searchOption == 'studentNo' ? 'selected' : ''}>작성자</option>
        </select>
        <input type="text" name="keyword" value="${searchQna}" placeholder="검색">
        <button type="submit">검색</button>
      </form>
    </div>

    <!-- Q&A 테이블 -->
    <table class="qna-table">
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
                <a href="#" onclick="handleSecretQna(${qna.qnaId}, '${loginUser.role}')">🔒 ${qna.title}</a>
              </c:when>
              <c:otherwise>
                <a style="color : #2c3e50" href="/qna/qnaOne?qnaId=${qna.qnaId}">${qna.title}</a>
              </c:otherwise>
            </c:choose>
          </td>
          <td>${qna.studentName}</td>
          <td>${qna.answerStatus}</td>
          <td><fmt:formatDate value="${qna.createDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
        </tr>
      </c:forEach>
    </table>

    <!-- 작성 버튼 -->
    <div class="button-group">
      <c:if test="${loginUser.role eq 'student'}">
        <a href="/qna/insertQna"><button type="button">작성</button></a>
      </c:if>
    </div>

    <!-- 페이징 -->
    <div class="pagination">
      <c:if test="${startPage > 1}">
        <a href="?currentPage=${startPage - 1}&searchOption=${searchOption}&keyword=${searchQna}">[이전]</a>
      </c:if>

       <c:forEach var="i" begin="${startPage}" end="${endPage}">
      <c:choose>
        <c:when test="${i == currentPage}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="?currentPage=${i}&filter=${param.filter}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>

      <c:if test="${endPage < page.lastPage}">
        <a href="?currentPage=${endPage + 1}&searchOption=${searchOption}&keyword=${searchQna}">[다음]</a>
      </c:if>
    </div>
  </div>

  <!-- 에러 메시지 -->
  <c:if test="${not empty errorMsg}">
    <script>alert("${errorMsg}");</script>
  </c:if>

  <!-- 비밀글 JS -->
  <script>
    function handleSecretQna(qnaId, role) {
      if (role === 'student') {
        const pw = prompt('비밀글입니다. 비밀번호를 입력하세요:');
        if (pw && pw.trim() !== '') {
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
        location.href = '/qna/qnaOne?qnaId=' + qnaId;
      }
    }
  </script>
</body>
</html>
