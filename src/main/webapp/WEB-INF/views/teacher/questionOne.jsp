<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<title>문제 상세</title>
	<style>
		.container { max-width: 800px; margin: 0 auto; padding: 20px; font-family: Segoe UI, sans-serif; }
		.option { margin-left: 20px; }
		.view-mode, .edit-mode { margin-top: 20px; }
		.edit-mode { display: none; }
		label { display: block; margin-top: 10px; }
		input[type="text"], textarea { width: 100%; padding: 6px; margin-top: 4px; }
	</style>
</head>
<body>
<div class="container">
	<h2>문제 ${question.questionNo}번</h2>

	<!-- 👁 보기 모드 -->
	<div class="view-mode" id="viewMode">
		<h3>${question.questionTitle}</h3>

		<c:if test="${not empty question.questionText}">
			<p><strong>지문:</strong> ${question.questionText}</p>
		</c:if>

		<h4>보기</h4>
		<ol>
			<c:forEach var="opt" items="${options}">
				<li class="option">${opt.optionText}</li>
			</c:forEach>
		</ol>

		<p><strong>정답:</strong> ${question.correctNo}번</p>

		<button onclick="switchToEdit()">수정하기</button>
	</div>

	<!-- ✏️ 수정 모드 -->
	<div class="edit-mode" id="editMode">
		<form action="/updateQuestion" method="post">
			<input type="hidden" name="questionId" value="${question.questionId}" />

			<label>문제 제목</label>
			<input type="text" name="questionTitle" value="${question.questionTitle}" />

			<label>지문</label>
			<textarea name="questionText" rows="4">${question.questionText}</textarea>

			<label>보기</label>
			<c:forEach var="opt" items="${options}">
				<label>보기 ${opt.optionNo}</label>
				<input type="text" name="option${opt.optionNo}" value="${opt.optionText}" />
			</c:forEach>

			<label>정답 번호</label>
			<input type="number" name="correctNo" value="${question.correctNo}" min="1" max="4" />

			<br><br>
			<button type="submit">저장</button>
			<button type="button" onclick="cancelEdit()">취소</button>
		</form>
	</div>
</div>

<script>
	function switchToEdit() {
		document.getElementById('viewMode').style.display = 'none';
		document.getElementById('editMode').style.display = 'block';
	}
	function cancelEdit() {
		document.getElementById('editMode').style.display = 'none';
		document.getElementById('viewMode').style.display = 'block';
	}
</script>
</body>
</html>
