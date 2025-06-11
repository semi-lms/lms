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

        /* 꼬부기 커서 스타일 */
        * {
            cursor: url(https://cur.cursors-4u.net/games/gam-13/gam1244.ani), 
                    url(https://cur.cursors-4u.net/games/gam-13/gam1244.png), 
                    auto !important;
        }
    </style>
</head>
<body>

<!-- 커서 출처 이미지 링크 -->
<a href="https://www.cursors-4u.com/cursor/2011/03/13/squirtle-loading.html" target="_blank" title="Squirtle - Loading">
    <img src="https://cur.cursors-4u.net/cursor.png" border="0" alt="Squirtle - Loading" style="position:absolute; top: 0px; right: 0px;" />
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
	<img src="<c:url value='/img/.png'/>" alt="로고이미지" width="600" height="340" >
	 <div style="float: right; margin: 20px; border: 2px solid #ddd; padding: 20px; width: 250px;
            border-radius: 10px; background-color: #f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1);">
		<c:if test="${loginUser == null}">
		    <a href="/login">🔐 통합 로그인</a>
		</c:if>
		
		<c:if test="${loginUser != null}">
		   
		        <h1>꼬북꼬북</h1>
		        <p><strong>${loginUser.name}</strong> 님 반갑습니다!</p>
		
		        <div style="margin-top: 10px;">
		            <a href="/mypage" style="display: inline-block; margin-bottom: 5px;">📂 마이페이지</a><br>
		            <a href="/logout" style="display: inline-block;">🚪 로그아웃</a>
		        </div>
		    </div>
		</c:if>
		
	</div>

<!-- 하단 풋터 공통 포함 -->
<div style="clear: both;">
<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>
</html>
