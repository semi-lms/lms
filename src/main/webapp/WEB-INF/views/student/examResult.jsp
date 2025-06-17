<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>시험 결과</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 900px;
            margin: 40px auto;
            background-color: #f7f9fc;
            color: #333;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            letter-spacing: 1px;
        }
        .score {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 25px;
            text-align: center;
            color: #2980b9;
        }
        .answer-list {
            border-collapse: collapse;
            width: 100%;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
        }
        .answer-list th, .answer-list td {
            padding: 12px 18px;
            text-align: center;
            border-bottom: 1px solid #e1e8ed;
        }
        .answer-list thead th {
            background-color: #2980b9;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .answer-list tbody tr:hover {
            background-color: #f1f6fb;
        }
        .correct {
            color: #155724;
            font-weight: bold;
            background-color: #d4edda;
            border-radius: 4px;
            padding: 4px 10px;
            display: inline-block;
        }
        .wrong {
            color: #721c24;
            font-weight: bold;
            background-color: #f8d7da;
            border-radius: 4px;
            padding: 4px 10px;
            display: inline-block;
        }
        a {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 25px;
            background-color: #2980b9;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: background-color 0.3s ease;
            font-weight: 600;
        }
        a:hover {
            background-color: #1c5980;
        }
        /* 반응형 */
        @media (max-width: 600px) {
            .answer-list th, .answer-list td {
                padding: 10px 8px;
            }
            .score {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>

<h2>시험 결과</h2>
<p class="score">총 점수: ${score} 점</p>

<table class="answer-list">
    <thead>
        <tr>
            <th>문제 번호</th>
            <th>선택한 답</th>
            <th>정답</th>
            <th>O/X</th>
        </tr>
    </thead>
    <tbody>
       <c:forEach var="answer" items="${answers}" varStatus="status">
        <tr>
            <td>${status.index + 1}</td>
            <td><c:out value="${answer.answerNo}" /></td>
            <td>${answer.correctNo }</td>
            <td>
                <c:choose>
                    <c:when test="${answer.answerNo == answer.correctNo}">
                        <span class="correct">O</span>
                    </c:when>
                    <c:otherwise>
                        <span class="wrong">X</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<br>
<a href="/student/examList">시험 목록으로 돌아가기</a>

</body>
</html>
