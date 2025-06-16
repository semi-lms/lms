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
    background-color: #f9fafb;
    margin: 0;
    padding: 20px;
    display: flex;
    justify-content: center; /* 가로 가운데 정렬 */
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

  table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
  }

  th, td {
    padding: 14px 18px;
    border-bottom: 1px solid #e1e4e8;
  }

  th {
    background-color: #007BFF;
    color: white;
    font-weight: 600;
  }

  tr:hover {
    background-color: #f1f5f9;
    cursor: pointer;
  }

  a {
    text-decoration: none;
    color: #007BFF;
    font-weight: 600;
  }

  a:hover {
    text-decoration: underline;
  }

  span {
    font-weight: 600;
    color: #555;
    margin: 0 6px;
  }

  /* pagination */
  .pagination {
    text-align: center;
    margin-top: 20px;
  }
</style>
</head>
<body>

<div class="container">
  <h1>시험 리스트</h1>
  <table>
    <tr>
      <th>제목</th>
      <th>시작일</th>
      <th>종료일</th>
      <th>응시여부</th>     
      <th>응시가능여부</th>
      <th>점수</th>
    </tr>
    <c:forEach var="exam" items="${exams}">
      <tr onclick="location.href='/student/takeExam?studentNo=${studentNo}&examId=${exam.examId}&page=1'">
        <td>${exam.title}</td>
        <td>${exam.examStartDate}</td>
        <td>${exam.examEndDate}</td>
        <td>${exam.submitStatus}</td> 
        <td>${exam.score}</td>
      </tr>
    </c:forEach>
  </table>

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
