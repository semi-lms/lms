<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <jsp:include page="/WEB-INF/views/common/header/adminHeader.jsp" />
  </c:when>
  <c:when test="${sessionScope.loginUser.role eq 'teacher'}">
    <jsp:include page="/WEB-INF/views/common/header/teacherHeader.jsp" />
  </c:when>
  <c:when test="${sessionScope.loginUser.role eq 'student'}">
    <jsp:include page="/WEB-INF/views/common/header/studentHeader.jsp" />
  </c:when>
  <c:otherwise>
    <jsp:include page="/WEB-INF/views/common/header/mainHeader.jsp" />
  </c:otherwise>
</c:choose>
	
<div class="section">
  <c:choose>
    <%-- 관리자: 이미지 + 그래프 + 마이페이지 --%>
    <c:when test="${sessionScope.loginUser.role eq 'admin'}">
      <div class="content" style="display: flex; justify-content: center; align-items: flex-start; gap: 30px;">
        <!-- 이미지 -->
        <div class="box" style="width: 30%;">
          <img src="<c:url value='/img/logo.png'/>" alt="학원이미지" style="width: 100%; max-width: 300px;">
        </div>

        <!-- 출석 통계 그래프 -->
        <div class="box" style="width: 30%;">
          <h4 style="text-align: center;">오늘의 출석 통계</h4>
          <canvas id="attendanceChart" width="300" height="250"></canvas>
        </div>

        <!-- 마이페이지 박스 -->
        <div style="width: 250px; border: 2px solid #ddd; padding: 20px;
            border-radius: 10px; background-color: #f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1);">
          <h1>꼬북꼬북</h1>
          <p>관리자</p>
          <div style="margin-top: 10px;">
            <a href="/mypage" style="display: inline-block; margin-bottom: 5px;">📂 마이페이지</a><br>
            <a href="/logout" style="display: inline-block;">🚪 로그아웃</a>
          </div>
        </div>
      </div>
    </c:when>

    <%-- 강사 / 학생: 이미지 + 마이페이지 --%>
    <c:when test="${sessionScope.loginUser.role eq 'teacher' or sessionScope.loginUser.role eq 'student'}">
      <div class="content" style="display: flex; justify-content: center; align-items: flex-start; gap: 30px;">
        <!-- 이미지 -->
        <div class="box" style="width: 50%;">
          <img src="<c:url value='/img/logo.png'/>" alt="학원이미지" style="width: 100%; max-width: 400px;">
        </div>

        <!-- 마이페이지 박스 -->
        <div style="width: 250px; border: 2px solid #ddd; padding: 20px;
            border-radius: 10px; background-color: #f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1);">
          <h1>꼬북꼬북</h1>
          <p><strong>${loginUser.name}</strong> 님 반갑습니다!</p>
          <div style="margin-top: 10px;">
            <a href="/mypage" style="display: inline-block; margin-bottom: 5px;">📂 마이페이지</a><br>
            <a href="/logout" style="display: inline-block;">🚪 로그아웃</a>
          </div>
        </div>
      </div>
    </c:when>

    <%-- 비로그인 사용자 --%>
    <c:otherwise>
      <div class="content" style="display: flex; justify-content: center; align-items: flex-start; gap: 30px;">
        <!-- 이미지 -->
        <div class="box" style="width: 50%;">
          <img src="<c:url value='/img/logo.png'/>" alt="로고이미지" style="width: 100%; max-width: 400px;">
        </div>

        <!-- 로그인 박스 -->
        <div style="width: 250px; border: 2px solid #ddd; padding: 20px;
            border-radius: 10px; background-color: #f9f9f9;
            box-shadow: 2px 2px 8px rgba(0,0,0,0.1);">
          <a href="/login">🔐 통합 로그인</a>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</div>


<!-- 하단 풋터 공통 포함 -->
<div style="clear: both;">
<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>


<!-- 오늘의 출석 통계 -->
<c:if test="${sessionScope.loginUser.role eq 'admin'}">
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script>
	    const courseNames = [
	        <c:forEach var="item" items="${list}" varStatus="status">
	            "${item.courseName}"<c:if test="${!status.last}">,</c:if>
	        </c:forEach>
	    ];
	
	    const totalCounts = [
	        <c:forEach var="item" items="${list}" varStatus="status">
	            ${item.total}<c:if test="${!status.last}">,</c:if>
	        </c:forEach>
	    ];
	
	    const attendedCounts = [
	        <c:forEach var="item" items="${list}" varStatus="status">
	            ${item.attended}<c:if test="${!status.last}">,</c:if>
	        </c:forEach>
	    ];
	
	    new Chart(document.getElementById('attendanceChart'), {
	        type: 'bar',
	        data: {
	            labels: courseNames,
	            datasets: [
	                {
	                    label: '총원',
	                    data: totalCounts,
	                    backgroundColor: 'rgba(54, 162, 235, 0.5)'
	                },
	                {
	                    label: '출석',
	                    data: attendedCounts,
	                    backgroundColor: 'rgba(75, 192, 192, 0.5)'
	                }
	            ]
	        },
	        options: {
	            responsive: false,
	            maintainAspectRatio: false,
	            plugins: {
	                legend: { display: false },
	                title: { display: false }
	            },
	            scales: {
	                y: { beginAtZero: true }
	            }
	        }
	    });
	</script>
</c:if>
</body>
</html>
