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
	padding: 8px 16px;
	margin: 4px;
	background: #007BFF;
	color: #fff;
	text-decoration: none;
	border-radius: 4px;
}

.nav-btn.disabled {
	background: #aaa;
	pointer-events: none;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<h1>시험 응시</h1>
	<p>문제 ${page} / 10 (시험 ID: ${examId})</p>
	<p>응시자번호 ${loginUser.studentNo }
	<form id="examForm" method="post" action="/student/submitExam">
		<input type="hidden" name="examId" value="${examId}" />
		
		<c:forEach var="q" items="${questions}" varStatus="status">
			<div class="question">
				<p>
					<strong>${q.questionNo}. ${q.questionTitle}</strong>
				</p>
				<p>${q.questionText}</p>

				<input type="hidden" name="answers[${status.index}].questionId"
					value="${q.questionId}" />

				<c:forEach var="opt" items="${q.options}">
					<label> <input type="radio"
						name="answers[${status.index}].answerNo" value="${opt.optionNo}"
						<c:if test="${tempAnswers[q.questionId] == opt.optionNo}">checked</c:if> />
						${opt.optionText}
					</label>
					<br />
				</c:forEach>
			</div>
		</c:forEach>


		<div>
			<c:if test="${page > 1}">
				<a href="?examId=${examId}&page=${page-1}" class="nav-btn">◀ 이전</a>
			</c:if>
			<c:if test="${page < 10}">
				<a href="?examId=${examId}&page=${page+1}" class="nav-btn">다음 ▶</a>
			</c:if>
			<c:if test="${page == 10}">
				<button type="submit" class="nav-btn">최종 제출</button>
			</c:if>
		</div>

	</form>

	<script>
//전역 객체에 누적 저장
  let savedAnswers = {};

  function saveTemp(questionId, answerNo) {
    savedAnswers[questionId] = answerNo;

    $.ajax({
      url: '/exam/api/saveTemp',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ questionId, answerNo }),
      success: function() { console.log('임시 저장 완료'); }
    });
  }

  // 제출 시 모든 누적 답변을 form에 추가
  $('#examForm').on('submit', function(e) {
    Object.entries(savedAnswers).forEach(([qid, ans], index) => {
      $(this).append(`<input type="hidden" name="answers[${index}].questionId" value="${qid}">`);
      $(this).append(`<input type="hidden" name="answers[${index}].answerNo" value="${ans}">`);
    });
  });


  $(document).ready(function() {
    $('input[type=radio]').on('change', function() {
      const questionId = $(this).closest('.question').find('input[name$=".questionId"]').val();
      const answerNo = $(this).val();
      saveTemp(parseInt(questionId), parseInt(answerNo));
    });
  });
</script>
</body>
</html>
