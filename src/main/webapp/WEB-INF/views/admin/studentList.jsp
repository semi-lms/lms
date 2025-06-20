<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>학생 리스트</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
  /* 공통 폰트 및 기본 스타일 */
 

  /* 컨테이너: sidebar + main-content */
  .container {
    display: flex;
    width: 100%;
  }



  /* 메인 컨텐츠 영역 */
.main-content {
  margin-left: 300px; /* 사이드바 너비와 동일하게 */
  padding: 40px;
  background-color: #fff;
  min-height: 100vh;
  box-sizing: border-box;
  position: relative;
}

  /* 제목 */
  h1 {
    font-size: 24px;
    margin-bottom: 24px;
  }

  /* 검색영역 */
  .search-container {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    margin-bottom: 16px;
    gap: 8px;
  }

  .search-container select,
  .search-container input[type="text"] {
    padding: 8px 12px;
    font-size: 14px;
    border: 1px solid #bbb;
    border-radius: 4px;
  }

  .search-container button {
    padding: 8px 14px;
    font-size: 14px;
    border: none;
    background-color: #2c3e50;
    color: white;
    border-radius: 4px;
    cursor: pointer;
  }

  .search-container button:hover {
    background-color: #0056b3;
  }

  /* 테이블 스타일 (공지/자료실과 동일) */
  table {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
    margin-bottom: 16px;
  }

  table th,
  table td {
    border: 1px solid #ddd;
    padding: 12px 10px;
    text-align: center;
    font-size: 14px;
  }
  

  table th {
    background-color: #2c3e50;
    font-weight: 600;
    color : white;
  }

  /* 버튼 영역 - 오른쪽 아래 고정 */
.button-group {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 30px;
  margin-right: 60px;
  flex-wrap: wrap;
}

  .button-group button {
    background-color: white;
    border: 1px solid black;
    color: black;
    padding: 10px 16px;
    margin-left: 8px;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
  }

  .button-group button:hover {
    background-color: #0056b3;
  }

  /* 페이징 스타일 (공지/자료실 스타일 참고) */
  .pagination {
    text-align: center;
    margin-top: 40px;
    user-select: none;
  }

  .pagination a,
  .pagination span {
    display: inline-block;
    margin: 0 4px;
    padding: 6px 12px;
    color: #2c3e50;
    border: 1px solid #ddd;
    border-radius: 4px;
    text-decoration: none;
    font-size: 14px;
  }

  .pagination a:hover {
    background-color: #2c3e50;
    color: white;
  }

  .pagination span {
    background-color: #2c3e50;
    color: white;
    border-color: #2c3e50;
    font-weight: 600;
    cursor: default;
  }
</style>
</head>
<body>
<div class="container">
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
  </div>
  <div class="main-content">
    <h1>학생 리스트</h1>

    <!-- 검색 영역 -->
    <form action="/admin/studentList" method="get" class="search-container">
      <select name="searchOption">
        <option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
        <option value="studentName" ${searchOption == 'studentName' ? 'selected' : ''}>이름</option>
        <option value="courseName" ${searchOption == 'courseName' ? 'selected' : ''}>수강과목</option>
      </select>
      <input type="text" name="keyword" id="keyword" value="${keyword != null ? keyword : ''}" />
      <button type="submit">검색</button>
    </form>

    <!-- 학생 리스트 테이블 -->
    <form>
      <table>
        <thead>
          <tr>
            <th>이름</th>
            <th>전화번호</th>
            <th>주민번호</th>
            <th>주소</th>
            <th>이메일</th>
            <th>아이디</th>
            <th>수강과목</th>
            <th>선택</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="sList" items="${studentList}">
            <tr>
              <td>${sList.name}</td>
              <td>${sList.phone}</td>
              <td>
                <c:choose>
                  <c:when test="${fn:length(sList.sn) == 13}">
                    <c:out value="${fn:substring(sList.sn, 0, 6)}" />-*******
                  </c:when>
                  <c:otherwise>
                    ${sList.sn}
                  </c:otherwise>
                </c:choose>
              </td>
              <td>${sList.address}</td>
              <td>${sList.email}</td>
              <td>${sList.studentId}</td>
              <td>${sList.courseName}</td>
              <td><input type="checkbox" class="selectStudent" value="${sList.studentNo}" /></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </form>

    <!-- 버튼 그룹 -->
    <div class="button-group">
      <c:if test="${loginUser.adminId eq 'admin'}">
        <button type="button" id="insertStudent">➕ 학생등록</button>
        <button type="button" id="modifyBtn">💾 수정</button>
        <button type="button" id="removeBtn">❌ 삭제</button>
      </c:if>
    </div>

    <!-- 페이징 -->
    <div class="pagination">
      <c:if test="${page.lastPage > 1}">
        <c:if test="${startPage > 1}">
          <a href="/admin/studentList?currentPage=${startPage-1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[이전]</a>
        </c:if>
      </c:if>
      <c:forEach var="i" begin="${startPage}" end="${endPage}">
        <c:choose>
          <c:when test="${i == page.currentPage}">
            <span>${i}</span>
          </c:when>
          <c:otherwise>
            <a href="/admin/studentList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">${i}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>
      <c:if test="${endPage < page.lastPage}">
        <a href="/admin/studentList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[다음]</a>
      </c:if>
    </div>
  </div>
</div>

<script>
  $(function () {
    $("#insertStudent").click(function () {
      window.location = "insertStudent";
    });

    $("#modifyBtn").click(function () {
      const checked = $(".selectStudent:checked");
      if (checked.length === 0) {
        alert("수정할 학생을 선택하세요.");
        return;
      }
      if (checked.length > 1) {
        alert("하나만 선택 가능합니다.");
        return;
      }
      const studentNo = checked.val();

      $.getJSON("/admin/getStudentDetail", { studentNo: studentNo }, function (student) {
        if (!student) {
          alert("학생 정보를 불러올 수 없습니다.");
          return;
        }
        // Modal 열기 등 추가 로직 필요시 작성
        alert("학생 수정 기능은 모달 구현 후 연결해주세요.");
      });
    });

    $("#removeBtn").click(function () {
      const checked = $(".selectStudent:checked");
      if (checked.length === 0) {
        alert("삭제할 학생을 선택하세요.");
        return;
      }
      if (!confirm("정말 삭제하시겠습니까?")) return;

      let studentIds = [];
      checked.each(function () {
        studentIds.push($(this).val());
      });

      $.ajax({
        url: "/admin/deleteStudents",
        type: "POST",
        traditional: true,
        data: { studentIds: studentIds },
        success: function (result) {
          alert("삭제 완료");
          location.reload();
        },
        error: function () {
          alert("삭제 실패");
        },
      });
    });
  });
</script>
</body>
</html>
