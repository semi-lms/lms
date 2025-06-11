<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>출석 통계 페이지</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
    <h1>출석 통계 페이지</h1>
    
    <!-- 1. 통계 테이블 -->
    <table border="1">
        <tr>
            <th>실제 출석(지각 포함)</th>
            <th>전체 출석 가능 횟수</th>
            <th>출석률(%)</th>
        </tr>
        <tr>
            <td>${actual}</td>
            <td>${attendanceTotalCount}</td>
            <td>
                <c:choose>
                    <c:when test="${attendanceTotalCount > 0}">
                        <fmt:formatNumber value="${(actual * 100.0) / attendanceTotalCount}" pattern="0.0"/>
                    </c:when>
                    <c:otherwise>0</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

    <!-- 2. 그래프 영역 -->
    <div class="chart-container">
        <canvas id="attendanceChart"></canvas>
    </div>
    
    <script>
        // JSP 변수 값 읽기
        var total = Number("${attendanceTotalCount}");
        var actual = Number("${actual}");
        var rate = total > 0 ? Math.round(actual / total * 1000) / 10 : 0; // 소수점1자리

        const ctx = document.getElementById('attendanceChart').getContext('2d');
        const attendanceChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['실제 출석', '전체 출석 가능'],
                datasets: [
                    {
                        label: '횟수',
                        data: [actual, total],
                        backgroundColor: ['#4bc0c080', '#4bc0c080']
                    },
                    {
                        label: '출석률(%)',
                        type: 'line',
                        data: [rate, null], // 실제 출석값에만 꺾은선(출석률) 표시
                        borderColor: '#f7b731',
                        borderWidth: 2,
                        fill: false,
                        yAxisID: 'rateAxis'
                    }
                ]
            },
            options: {
                responsive: false,
                plugins: {
                    legend: { display: true }
                },
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: '횟수' } },
                    rateAxis: {
                        position: 'right',
                        beginAtZero: true,
                        min: 0,
                        max: 100,
                        title: { display: true, text: '출석률(%)' }
                    }
                }
            }
        });
    </script>
</body>
</html>
