<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<title>시험 응시</title>
<style>
body {
	font-family: Arial, sans-serif;
	max-width: 800px;
	margin: auto;
}

.question {
	border: 1px solid #ccc;
	padding: 16px;
	margin-bottom: 24px;
}

.nav-btn {
	padding: 10px 20px;
	margin-top: 20px;
	background: #007BFF;
	color: #fff;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 16px;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
<br>

<p>시험 ID: ${examId}</p>
<p>응시자번호: ${loginUser.studentNo}</p>

<form id="examForm" method="post" action="/student/submitExam">
	<input type="hidden" name="examId" value="${examId}" />
	<div id="hiddenAnswersContainer"></div>

<c:forEach var="q" items="${questions}" varStatus="status">
  <div class="question">
    <p><strong>${q.questionNo}. ${q.questionTitle}</strong></p>
    <p>${q.questionText}</p>

    <input type="hidden" name="answers[${status.index}].questionId" value="${q.questionId}" />

    <c:forEach var="opt" items="${q.options}">
      <label>
        <input type="radio"
               class="answer-radio"
               data-question-id="${q.questionId}"
               name="answers[${status.index}].answerNo"
               value="${opt.optionNo}"
               <c:if test="${tempAnswers[q.questionId] == opt.optionNo}">checked</c:if> />
        ${opt.optionText}
      </label><br/>
    </c:forEach>
  </div>
</c:forEach>
	<button type="submit" class="nav-btn">최종 제출</button>
</form>

</body>


</html>
