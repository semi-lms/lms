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
	<p>응시자번호 ${loginUser.studentNo } </p>
	<form id="examForm" method="post" action="/student/submitExam">
		<input type="hidden" name="examId" value="${examId}" />
<c:forEach var="q" items="${questions}" varStatus="status">
  <div class="question">
    <p><strong>${q.questionNo}. ${q.questionTitle}</strong></p>
    <p>${q.questionText}</p>

    <!-- 배열 형태로 questionId 전송 -->
    <input type="hidden" name="answers[${status.index}].questionId" value="${q.questionId}" />

    <!-- 보기 반복 -->
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
  // 저장된 답안 객체
  const savedAnswers = {};

  // 현재 체크된 답안들을 savedAnswers에 모으는 함수
  function collectAllCheckedAnswers() {
    $('input.answer-radio:checked').each(function () {
      const questionId = $(this).data('question-id');
      const answerNo = $(this).val();
      savedAnswers[questionId] = answerNo;
    });
  }

  // 페이지 이동 버튼 누를 때 강제 저장
  $(document).on('click', 'a.nav-btn', function(e) {
    e.preventDefault(); // 기본 링크 이동 막기

    // 체크된 답안들 갱신
    collectAllCheckedAnswers();

    // 서버로 임시 저장 요청들
    const savePromises = [];
    for (const [questionId, answerNo] of Object.entries(savedAnswers)) {
      savePromises.push($.ajax({
        url: '/exam/api/saveTemp',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ questionId, answerNo })
      }));
    }

    // 저장 다 완료되면 페이지 이동
    Promise.all(savePromises).then(() => {
      window.location.href = $(this).attr('href');
    });
  });

  // 라디오 버튼 변경 시 바로 서버로 임시 저장
  $(document).ready(function () {
    $('input.answer-radio').on('change', function () {
      const questionId = $(this).data('question-id');
      const answerNo = $(this).val();
      savedAnswers[questionId] = answerNo;

      $.ajax({
        url: '/exam/api/saveTemp',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ questionId, answerNo }),
        success: function () {
          console.log('임시 저장 완료');
        }
      });
    });

    // 페이지 로드시 서버에 저장된 임시 답안 불러와서 체크 상태 복원
    $.ajax({
      url: '/exam/api/loadTemp',
      type: 'GET',
      success: function(data) {
        // data 예: { "10": "3", "11": "2", ... }
        for (const [questionId, answerNo] of Object.entries(data)) {
          savedAnswers[questionId] = answerNo;
          $(`input.answer-radio[data-question-id="${questionId}"][value="${answerNo}"]`).prop('checked', true);
        }
      }
    });
  });
</script>


</body>
</html>
