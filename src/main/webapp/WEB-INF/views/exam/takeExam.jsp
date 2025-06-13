<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<form action="${pageContext.request.contextPath}/student/exam/submit" method="post">
    <input type="hidden" name="examId" value="${exam.examId}" />

    <c:forEach var="q" items="${questions}">
        <div>
            <h4>문제 ${q.questionNo}. ${q.questionTitle}</h4>
            <c:if test="${not empty q.questionText}">
                <p>${q.questionText}</p>
            </c:if>

            <c:forEach var="opt" items="${q.options}">
                <label>
                    <input type="radio" name="q${q.questionId}" value="${opt.optionNo}" required />
                    ${opt.optionText}
                </label><br/>
            </c:forEach>
        </div>
        <hr/>
    </c:forEach>

    <button type="submit">제출</button>
</form>

</body>
</html>
