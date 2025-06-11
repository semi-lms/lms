<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 간단한 레이아웃 스타일 */
        .header, .footer { display: flex; justify-content: space-between; padding: 10px; }
        .nav a { margin-right: 15px; }
        .section { text-align: center; margin-top: 30px; }
        .content { display: flex; justify-content: space-around; padding: 20px; }
        .box { width: 30%; }

        /* 마리오 커서 스타일 */
        * {
            cursor: url(https://cur.cursors-4u.net/games/gam-1/gam62.cur), auto !important;
        }
    </style>
</head>
<body>

<!-- 마리오 커서 출처 및 아이콘 -->
<a href="https://www.cursors-4u.com/cursor/2006/03/26/gam62.html" target="_blank" title="Mario">
    <img src="https://cur.cursors-4u.net/cursor.png" border="0" alt="Mario" style="position:absolute; top: 0px; right: 0px;" />
</a>

<!-- 헤더 : 로고와 사이트명 -->
<c:choose>
  <c:when test="${sessionScope.loginUser.role eq 'admin'}">
    <jsp:include page="/WEB-INF/views/header/adminHeader.jsp" />
  </c:when>
  <c:when test="${sessionScope.loginUser.role eq 'teacher'}">
    <jsp:include page="/WEB-INF/views/header/teacherHeader.jsp" />
  </c:when>
  <c:when test="${sessionScope.loginUser.role eq 'student'}">
    <jsp:include page="/WEB-INF/views/header/studentHeader.jsp" />
  </c:when>
  <c:otherwise>
    <jsp:include page="/WEB-INF/views/header/mainHeader.jsp" />
  </c:otherwise>
</c:choose>
	
<!-- 중앙 : 이미지, 로그인 버튼 -->
<div class="section">
	<img src="/img/logo.png" alt="학원이미지" width="600" height="340">
	<br><br>
	<div style="text-align: right; width: 600px; margin: 0 auto;">
		<a href="/login"><button>통합 로그인</button></a>
		<a href="/logout"><button>로그아웃</button></a>
	</div>
</div>

<!-- 하단 풋터 공통 포함 -->
<jsp:include page="/WEB-INF/views/footer.jsp" />

</body>
</html>
