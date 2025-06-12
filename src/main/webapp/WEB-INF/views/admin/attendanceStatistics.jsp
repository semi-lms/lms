<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석 통계 페이지</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<style>
.container {
	display: flex;
}

.sidebar {
	min-width: 200px;
}

.main-content {
	flex: 1;
	margin-left: 32px;
}
</style>
<body>
	<div class="container">
		<div class="sidebar">
			<!-- 기존 왼쪽 메뉴 jsp 인클루드 -->
			<jsp:include page="/WEB-INF/views/common/header/adminHeader.jsp" />
		</div>
		<div class="main-content">
			<h1>출석 통계 페이지</h1>

			<!-- 1. 통계 테이블 -->
			<table border="1">
				<tr>
					<th>반</th>
					<th>실제 출석(지각 포함)</th>
					<th>전체 출석 가능 횟수</th>
					<th>출석률(%)</th>
				</tr>
				<c:forEach var="i" begin="0" end="${fn:length(classNames) - 1}">
					<tr>
						<td>${classNames[i]}</td>
						<td>${actuals[i]}</td>
						<td>${attendanceTotalCounts[i]}</td>
						<td><c:choose>
								<c:when test="${attendanceTotalCounts[i] > 0}">
									<fmt:formatNumber
										value="${(actuals[i] * 100.0) / attendanceTotalCounts[i]}"
										pattern="0.0" />
								</c:when>
								<c:otherwise>0</c:otherwise>
							</c:choose></td>
					</tr>
				</c:forEach>
			</table>

			<!-- 2. 그래프 영역 -->
			<div class="chart-container">
				<canvas id="attendanceChart" width="500" height="350"></canvas>
			</div>
		</div>
	</div>

	<script>
    // JSTL로 리스트 → JS 배열
    const labels = [
        <c:forEach var="n" items="${classNames}" varStatus="s">
            "${n}"<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    const actuals = [
        <c:forEach var="v" items="${actuals}" varStatus="s">
            ${v}<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    const totals = [
        <c:forEach var="v" items="${attendanceTotalCounts}" varStatus="s">
            ${v}<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    // 출석률 (%) 배열 생성
    const rates = actuals.map((v, i) => totals[i] > 0 ? Math.round(v / totals[i] * 1000) / 10 : 0);

    const ctx = document.getElementById('attendanceChart').getContext('2d');
    const attendanceChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                {
                    label: '실제 출석',
                    data: actuals,
                    backgroundColor: '#1e90ffcc',
                    borderColor: '#1e90ff',
                    borderWidth: 2,
                    yAxisID: 'y',
                },
                {
                    label: '전체 출석 가능',
                    data: totals,
                    backgroundColor: '#ff3b30cc',
                    borderColor: '#ff3b30',
                    borderWidth: 2,
                    yAxisID: 'y',
                },
                {
                    label: '출석률(%)',
                    data: rates,
                    type: 'line',
                    borderColor: '#4cd964',
                    borderWidth: 2,
                    pointBackgroundColor: '#4cd964',
                    fill: false,
                    yAxisID: 'y1',
                    tension: 0.2
                }
            ]
        },
        options: {
            responsive: false,
            plugins: {
                legend: { display: true, position: 'bottom' }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: { display: true, text: '횟수' }
                },
                y1: {
                    position: 'right',
                    beginAtZero: true,
                    min: 0,
                    max: 100,
                    title: { display: true, text: '출석률(%)' },
                    grid: { drawOnChartArea: false }
                }
            }
        }
    });
</script>
</body>
</html>
