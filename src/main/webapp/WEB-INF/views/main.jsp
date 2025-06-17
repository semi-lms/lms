<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>LMS 메인</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">  
</head>
<body>

	<!-- 헤더 include -->
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

	<!-- 메인 비디오 및 마이페이지 -->
	<div class="main-section">
		<div class="card video-card">
			<video autoplay muted loop>
				<source src="<c:url value='/video/goodee.mp4'/>" type="video/mp4">
			</video>
		</div>

		<c:choose>
		  <c:when test="${not empty loginUser}">
		    <c:choose>
		      <c:when test="${loginUser.role eq 'admin'}">
		        <div class="card mypage-box">
		          <h2>김예진/노민혁 님</h2>
		          <p>역할: ${loginUser.role}</p>
		          <a href="/mypage" class="btn">마이페이지</a>
		          <a href="/logout" class="btn logout">로그아웃</a>
		        </div>
		      </c:when>
		      <c:otherwise>
		        <div class="card mypage-box">
		          <h2>${loginUser.name}님</h2>
		          <p>역할: ${loginUser.role}</p>
		          <a href="/mypage" class="btn">마이페이지</a>
		          <a href="/logout" class="btn logout">로그아웃</a>
		        </div>
		      </c:otherwise>
		    </c:choose>
		  </c:when>
		
		  <c:otherwise>
		    <div class="card mypage-box">
		      <h2>환영합니다!</h2>
		      <p>로그인이 필요합니다.</p>
		      <a href="/login" class="btn">로그인</a>
		    </div>
		  </c:otherwise>
		</c:choose>
	</div>

	<!-- 관리자용 출석 통계 -->
	<c:if test="${sessionScope.loginUser.role eq 'admin'}">
		<div class="main-section">
			<div class="card">
				<h3>오늘의 출석 통계</h3>
				<canvas id="attendanceChart"></canvas>
			</div>
		</div>

		<script>
    const classroom = [
      <c:forEach var="item" items="${list}" varStatus="status">
        "${item.classroom}"<c:if test="${!status.last}">,</c:if>
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
    const ctx = document.getElementById('attendanceChart');
    const myChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: classroom,
        datasets: [
          {
            label: '총원',
            data: totalCounts,
            backgroundColor: 'rgba(54, 162, 235, 0.6)'
          },
          {
            label: '출석',
            data: attendedCounts,
            backgroundColor: 'rgba(75, 192, 192, 0.6)'
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          title: {
            display: true,
            text: '오늘의 출석 현황'
          },
          legend: {
            display: true
          }
        },
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    });

    ctx.onclick = function() {
      location.href = "/admin/attendanceStatistics";
    };
  </script>
	</c:if>
	<!-- 삼담문의 배너 -->
	<div class="floBanPc3">
	  <a href="tel:028187950">
	    <img src="https://cdn.imweb.me/upload/S202407158b5a524da5594/40ffd7b4f910b.png" width="150px" height="150px">
	  </a>
	</div>
	<!-- 공통 하단 컨텐츠 include -->
	<jsp:include page="/WEB-INF/views/common/commonMain.jsp" />

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	
</body>
</html>
