<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>구디아카데미 LMS</title>
<link rel="icon" href="${pageContext.request.contextPath}/img/cursor.png" type="image/png">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

	<img src="${pageContext.request.contextPath}/img/cursor.png"
		id="custom-cursor" />

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

	<!-- 메인 콘텐츠 -->
	<div class="main-section">
		<!-- 왼쪽 비디오 카드 -->
		<div class="card video-card">
			<video autoplay muted loop>
				<source src="<c:url value='/video/goodee.mp4'/>" type="video/mp4">
			</video>
		</div>

		<!-- 오른쪽 박스들 -->
		<div class="side-section">
			<!-- 마이페이지 박스 -->
			<c:choose>
				<c:when test="${not empty loginUser}">

					<div class="card mypage-box">

						<h2>
							${loginUser.name}
							<c:if test="${loginUser.role ne 'admin'}">님</c:if>
						</h2>
						<p>
							<c:choose>
								<c:when test="${loginUser.role eq 'student'}">학생</c:when>
								<c:when test="${loginUser.role eq 'teacher'}">강사</c:when>
								<c:when test="${loginUser.role eq 'admin'}">관리자</c:when>
								<c:otherwise>${loginUser.role}</c:otherwise>
							</c:choose>
						</p>
							<c:if test="${loginUser.role ne 'admin'}">
						<a href="/mypage" class="btn">마이페이지</a> 
						</c:if>
						<a href="/logout"class="btn logout">로그아웃</a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="card mypage-box">
						<h2>환영합니다!</h2>
						<p>로그인이 필요합니다.</p>
						<a href="/login" class="btn">로그인</a>
					</div>
				</c:otherwise>
			</c:choose>

			<!-- 관리자: 통계 / 그 외: 날씨 -->
			<c:choose>
				<c:when test="${loginUser.role eq 'admin'}">
					<div class="card info-box">
						<h3>오늘의 출석 통계</h3>
						<canvas id="attendanceChart"></canvas>
					</div>
				</c:when>
				<c:otherwise>
					<div class="card info-box" id="weather">
						<p id="weather-location"></p>
						<img id="weather-icon" src="" alt="날씨 아이콘"
							style="width: 80px; height: 80px; display: none;">
						<p id="weather-temp"></p>
						<p id="weather-desc"></p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
<img src="https://cdn.imweb.me/upload/S202407158b5a524da5594/40ffd7b4f910b.png"
     class="floating-img" width="150" height="150">
	<!-- 통계 JS -->
	<c:if test="${loginUser.role eq 'admin'}">
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

    const ctx = document.getElementById('attendanceChart').getContext('2d');
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
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    ctx.canvas.onclick = function () {
        location.href = "/admin/attendanceStatistics";
    };
</script>
	</c:if>

	<!-- 날씨 JS -->
	<c:if test="${loginUser.role ne 'admin'}">

		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

		<script>
    fetch("https://api.openweathermap.org/data/2.5/weather?q=Seoul&appid=7ffda95e88ecbf36cebafb2a3089b0ca&units=metric&lang=kr")
        .then(response => response.json())
        .then(data => {
            if (data.cod === 200) {
                const iconCode = data.weather[0].icon;
                const iconUrl = `https://openweathermap.org/img/wn/04d@2x.png`;

                document.getElementById('weather-location').textContent = '📍' + data.name;
                document.getElementById('weather-temp').textContent = '🌡' + data.main.temp.toFixed(1) + ' °C';
                document.getElementById('weather-desc').textContent = '🌤' + data.weather[0].description;

                const iconImg = document.getElementById('weather-icon');
                iconImg.src = iconUrl;
                iconImg.style.display = 'block';
            } else {
                document.getElementById('weather').innerHTML = '<p>날씨 정보를 가져올 수 없습니다.</p>';
            }
        })
        .catch(error => {
            document.getElementById('weather').innerHTML = '<p>API 호출 중 오류가 발생했습니다.</p>';
            console.error(error);
        });
</script>

	</c:if>

	<!-- 기타 하단 -->
	<jsp:include page="/WEB-INF/views/common/commonMain.jsp" />
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

	<script>
document.addEventListener('DOMContentLoaded', () => {
    const cursorImg = document.getElementById('custom-cursor');
    document.addEventListener('mousemove', function (e) {
        cursorImg.style.left = (e.clientX + 30) + 'px';
        cursorImg.style.top = (e.clientY + 30) + 'px';
    });
});
</script>

</body>
</html>
