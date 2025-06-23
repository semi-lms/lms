<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<title>문제 상세</title>
		<style>
	body {
		background-color: #f4f6f8;
		margin: 0;
		padding: 0;
		font-family: 'Segoe UI', sans-serif;
	}

	.container {
		max-width: 800px;
		margin: 40px auto;
		padding: 30px;
		background-color: #fff;
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
		border-radius: 8px;
	}

	h2 {
		margin-top: 0;
		color: #333;
	}

	h3, h4 {
		color: #444;
	}

	p {
		line-height: 1.6;
		color: #555;
	}

	.option {
		margin-left: 20px;
		padding: 6px 0;
	}

	.view-mode, .edit-mode {
		margin-top: 20px;
	}

	.edit-mode {
		display: none;
	}

	label {
		display: block;
		margin-top: 15px;
		font-weight: 600;
		color: #333;
	}

	input[type="text"],
	input[type="number"],
	textarea {
		width: 100%;
		padding: 10px;
		margin-top: 5px;
		border: 1px solid #ccc;
		border-radius: 5px;
		font-size: 15px;
		box-sizing: border-box;
		transition: border-color 0.3s ease;
	}

	input:focus,
	textarea:focus {
		border-color: #4a90e2;
		outline: none;
	}

	button {
		margin-top: 20px;
		margin-right: 10px;
		padding: 10px 20px;
		background-color: #4a90e2;
		color: white;
		border: none;
		border-radius: 5px;
		cursor: pointer;
		font-size: 14px;
		transition: background-color 0.3s ease;
	}

	button:hover {
		background-color: #357ab8;
	}

	button[type="button"] {
		background-color: #aaa;
	}

	button[type="button"]:hover {
		background-color: #888;
	}

	.sidebar {
		margin-bottom: 20px;
	}
</style>

	
</head>
<body>
<div class="container">
	<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
		</div>
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
