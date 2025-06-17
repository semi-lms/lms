<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석 통계 페이지</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
body { margin: 0; padding: 0; }
.container { display: flex; width: 100%; }
.sidebar { min-width: 220px; background: #fafafa; height: 100vh; }
.chart-container { margin-top: 32px; }
.main-content { flex: 1; background: #fff; padding: 40px 40px 40px 300px; }
</style>
</head>
<body>

<div class="container">
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
  </div>
  <div class="main-content">
        <h1>출석 통계 페이지</h1>
        <!-- 통계 테이블 : 반별 출석 데이터 표로 출력 -->
        <table border="1">
            <tr>
                <th>반</th>
                <th>강의명</th>
                <th>출석 가능 일수</th>
                <th>실제 출석</th>
                <th>출석률(%)</th>
            </tr>
            <!-- 각 반 별로 반복 -->
            <c:forEach var="i" begin="0" end="${fn:length(classNames) - 1}">
                <tr>
                    <td>${classNames[i]}</td>
                    <td>${courseNames[i]}</td>
                    <td>${attendanceTotalCounts[i]}</td>
                    <td>${actuals[i]}</td>
                    <td>
                        <!-- 0으로 나누는 오류 방지 -->
                        <c:choose>
                            <c:when test="${attendanceTotalCounts[i] > 0}">
                                <fmt:formatNumber value="${(actuals[i] * 100.0) / attendanceTotalCounts[i]}" pattern="0.0"/>
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <div class="chart-container">
            <canvas id="attendanceChart" width="500" height="350"></canvas>
        </div>
    </div>
</div>

<script>
    // JSTL 배열을 JS 배열로 변환
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
    // 출석률(%) 계산 (정수 + 소수 1자리)
    const rates = actuals.map((v, i) => totals[i] > 0 ? Math.round(v / totals[i] * 1000) / 10 : 0);
    // 반별 courseId 배열 (차트 클릭 시 이동용)
    const courseIds = [
        <c:forEach var="id" items="${courseIds}" varStatus="s">
            ${id}<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    // Chart.js 그래프 그리기
    const ctx = document.getElementById('attendanceChart').getContext('2d');
    const attendanceChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                {
                    label: '전체 출석 가능',
                    data: totals,
                    backgroundColor: '#1e90ffcc',
                    borderColor: '#1e90ff',
                    borderWidth: 2,
                    yAxisID: 'y',
                },
                {
                    label: '실제 출석',
                    data: actuals,
                    backgroundColor: '#ffd600cc',
                    borderColor: '#ffd600',        
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
    
    // 차트 클릭 시 해당 반 출석 상세로 이동
    document.getElementById('attendanceChart').onclick = function(evt) {
        const points = attendanceChart.getElementsAtEventForMode(evt, 'nearest', { intersect: true }, true);
        if (points.length) {
            const firstPoint = points[0];
            const courseId = courseIds[firstPoint.index];
            window.location.href = '/admin/attendanceByClass?courseId=' + courseId;
        }
    }
    
    // 차트에 마우스 올리면 커서 변경
    document.getElementById('attendanceChart').style.cursor = 'pointer';
</script>
</body>
</html>
