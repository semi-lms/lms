<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<title>시험 결과</title>
<style>
.content-wrapper {
	margin-left: 250px;
	padding: 40px;
	background-color: #f7f9fc;
	min-height: 100vh;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	color: #333;
}

.content-wrapper h2 {
	text-align: center;
	color: #2c3e50;
	margin-bottom: 30px;
	letter-spacing: 1px;
}

.content-wrapper .score {
	font-size: 26px;
	font-weight: 600;
	margin-bottom: 25px;
	text-align: center;
	color: #2980b9;
}

.table-container {
	max-width: 700px;
	margin: 0 auto;
	overflow-x: auto;
}

.answer-list {
	border-collapse: collapse;
	width: 100%;
	background-color: white;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	border-radius: 8px;
	overflow: hidden;
	font-size: 14px;
}

.answer-list th, .answer-list td {
	padding: 8px 12px;
	text-align: center;
	border-bottom: 1px solid #e1e8ed;
}

.answer-list thead th {
	background-color: #2980b9;
	color: white;
	font-weight: 600;
	letter-spacing: 0.03em;
}

.answer-list td:first-child, .answer-list th:first-child {
	width: 60px;
}

.answer-list td:last-child, .answer-list th:last-child {
	width: 60px;
}

.correct {
	color: #155724;
	background-color: #d4edda;
	border-radius: 4px;
	padding: 2px 8px;
	font-weight: bold;
	font-size: 13px;
	display: inline-block;
}

.wrong {
	color: #721c24;
	background-color: #f8d7da;
	border-radius: 4px;
	padding: 2px 8px;
	font-weight: bold;
	font-size: 13px;
	display: inline-block;
}

.table-footer {
	display: flex;
	justify-content: flex-end;
	margin-top: 20px;
	max-width: 700px;
	margin-left: auto;
	margin-right: auto;
}

.table-footer a {
	padding: 6px 12px;
	font-size: 14px;
	background-color: #2980b9;
	color: white;
	text-decoration: none;
	border-radius: 6px;
	font-weight: 500;
	transition: background-color 0.3s ease;
}

.table-footer a:hover {
	background-color: #1c5980;
}

.content-wrapper a:hover {
	background-color: #1c5980;
}

@media ( max-width : 600px) {
	.answer-list th, .answer-list td {
		padding: 6px 8px;
		font-size: 12px;
	}
	.content-wrapper .score {
		font-size: 20px;
	}
}
</style>
</head>
<body>

	<div class="sidebar">
		<jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
	</div>

	<div class="content-wrapper">
		<h2>시험 결과</h2>
		<p class="score">총 점수: ${score}0점</p>

		<div class="table-container">
			<table class="answer-list">
				<thead>
					<tr>
						<th>문제</th>
						<th>선택</th>
						<th>정답</th>
						<th>O/X</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="answer" items="${answers}" varStatus="status">
						<tr>
							<td>${status.index + 1}</td>
							<td><c:out value="${answer.answerNo}" /></td>
							<td>${answer.correctNo}</td>
							<td><c:choose>
									<c:when test="${answer.answerNo == answer.correctNo}">
										<span class="correct">O</span>
									</c:when>
									<c:otherwise>
										<span class="wrong">X</span>
									</c:otherwise>
								</c:choose></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<div class="table-footer">
			<a href="/student/examList">시험 목록으로 돌아가기</a>
		</div>
	</div>

</body>
</html>
