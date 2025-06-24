<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시험 리스트</title>
<style>
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0;
    padding: 20px;
    display: flex;
    justify-content: center;
  }

  .container {
    width: 90%;
    max-width: 900px;
    background: #fff;
    padding: 30px 40px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    border-radius: 8px;
  }

  h1 {
    text-align: center;
    margin-bottom: 30px;
    color: #333;
  }

  .card-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
  }

  .card {
    background: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    padding: 20px;
    width: 250px;
    cursor: pointer;
    transition: box-shadow 0.3s ease;
  }

  .card:hover {
    box-shadow: 0 6px 12px rgba(0,0,0,0.15);
  }

  .card.disabled {
    background: white;
    color: #999;
    cursor: default;
    box-shadow: none;
  }

  .card.disabled:hover {
    box-shadow: none;
  }

  .card h3 {
    margin: 0 0 12px;
    color: #007BFF;
  }

  .card.disabled h3 {
    color: #999;
  }

  .card p {
    margin: 6px 0;
    font-weight: 600;
    color: #555;
  }

  .card.disabled p {
    color: #999;
  }

  .pagination {
    text-align: center;
    margin-top: 30px;
  }

  .pagination span {
    font-weight: 600;
    color: #555;
    margin: 0 6px;
  }

  .pagination a {
    text-decoration: none;
    color: #007BFF;
    font-weight: 600;
  }

  .pagination a:hover {
    text-decoration: underline;
  }

  .text-success {
    color: #28a745;
    font-weight: 600;
  }
</style>
</head>
<body>
<div class="sidebar">
  <jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
</div>

<div class="container">
  <h1>${loginUser.name}님의 시험 목록</h1>

  <div class="card-list">
    <c:forEach var="exam" items="${exams}">
      <c:choose>
        <c:when test="${exam.status == '불가' and exam.submitStatus != '응시완료'}">
          <div class="card disabled">
            <h3>${exam.title}</h3>
            <p>시작일: ${exam.examStartDate}</p>
            <p>종료일: ${exam.examEndDate}</p>
            <p>응시여부: ${exam.submitStatus}</p>
            <p>응시가능여부: ${exam.status}</p>
            <p>점수: ${exam.score}0점</p>
          </div>
        </c:when>
        <c:otherwise>
          <div class="card" onclick="location.href='/student/takeExam?studentNo=${studentNo}&examId=${exam.examId}&page=1'">
            <h3>${exam.title}</h3>
            <p>시작일: ${exam.examStartDate}</p>
            <p>종료일: ${exam.examEndDate}</p>

            <c:choose>
              <c:when test="${exam.submitStatus == '응시완료'}">
                <p class="text-success">응시여부: ${exam.submitStatus}</p>
              </c:when>
              <c:otherwise>
                <p>응시여부: ${exam.submitStatus}</p>
              </c:otherwise>
            </c:choose>

            <c:choose>
              <c:when test="${exam.status == '가능'}">
                <p class="text-success">응시가능여부: ${exam.status}</p>
              </c:when>
              <c:otherwise>
                <p>응시가능여부: ${exam.status}</p>
              </c:otherwise>
            </c:choose>

            <p>점수: ${exam.score}0점</p>
          </div>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </div>

  <div class="pagination">
    <c:forEach var="i" begin="1" end="${endPage}">
      <c:choose>
        <c:when test="${i == currentPage}">
          <span>[${i}]</span>
        </c:when>
        <c:otherwise>
          <a href="/examList?currentPage=${i}">[${i}]</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </div>
</div>
</body>
</html>
