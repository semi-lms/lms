<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>시험 페이지</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    // 답안 임시 저장 ajax 함수
    function saveAnswerTemporary(questionId, answerNo) {
      $.ajax({
        url: '/student/saveAnswerTemporary',  
        method: 'POST',
        data: {
          questionId: questionId,
          answerNo: answerNo
        },
        success: function(res) {
          console.log('임시 저장 완료:', res);
        },
        error: function() {
          alert('임시 저장 실패');
        }
      });
    }

    // 선택지 클릭 시 호출되는 함수
    function selectAnswer(questionId, answerNo) {
      // 화면에서 선택 효과 줄 수 있음 (optional)
      $('input[name="answer_'+questionId+'"]').prop('checked', false);
      $('#answer_'+questionId+'_'+answerNo).prop('checked', true);

      // 임시 저장 ajax 호출
      saveAnswerTemporary(questionId, answerNo);
    }
  </script>
</head>
<body>
  <h1>시험 문제</h1>

  <form id="examForm" method="post" action="/student/submitExam">
    <%-- 예시 문제 3개만 표시 --%>
    <div>
      <p>1. 질문 1</p>
      <input type="radio" name="answer_1" id="answer_1_1" value="1" onclick="selectAnswer(1,1)"> 보기 1<br>
      <input type="radio" name="answer_1" id="answer_1_2" value="2" onclick="selectAnswer(1,2)"> 보기 2<br>
      <input type="radio" name="answer_1" id="answer_1_3" value="3" onclick="selectAnswer(1,3)"> 보기 3<br>
    </div>

    <div>
      <p>2. 질문 2</p>
      <input type="radio" name="answer_2" id="answer_2_1" value="1" onclick="selectAnswer(2,1)"> 보기 1<br>
      <input type="radio" name="answer_2" id="answer_2_2" value="2" onclick="selectAnswer(2,2)"> 보기 2<br>
      <input type="radio" name="answer_2" id="answer_2_3" value="3" onclick="selectAnswer(2,3)"> 보기 3<br>
    </div>

    <div>
      <p>3. 질문 3</p>
      <input type="radio" name="answer_3" id="answer_3_1" value="1" onclick="selectAnswer(3,1)"> 보기 1<br>
      <input type="radio" name="answer_3" id="answer_3_2" value="2" onclick="selectAnswer(3,2)"> 보기 2<br>
      <input type="radio" name="answer_3" id="answer_3_3" value="3" onclick="selectAnswer(3,3)"> 보기 3<br>
    </div>

    <button type="submit">시험 제출하기</button>
  </form>
</body>
</html>