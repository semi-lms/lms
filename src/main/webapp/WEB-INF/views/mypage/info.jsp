<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${loginUser.role ne 'admin'}">
<div class="mypage-section">
  <h3>👤 개인정보</h3>
  <form id="updateForm">
    
    <!-- 아이디 -->
    <div class="form-group">
      <label for="userIdInput">아이디:</label>
      <c:choose>
        <c:when test="${loginUser.role eq 'teacher'}">
          <input type="text" id="userIdInput" name="teacherId" value="${loginUser.teacherId}" />
        </c:when>
        <c:when test="${loginUser.role eq 'student'}">
          <input type="text" id="userIdInput" name="studentId" value="${loginUser.studentId}" readonly />
        </c:when>
      </c:choose>
      <button type="button" id="checkBtn">중복확인</button>
    </div>

    <!-- 비밀번호 -->
    <!-- 현재 비밀번호 -->
	<div class="form-group">
	  <label for="currentPassword">현재 비밀번호:</label>
	  <input type="password" name="currentPassword" id="currentPassword" />
	  <span class="error" id="currentPwError"></span>
	</div>
	
    <div class="form-group">
      <label for="newPassword">변경 비밀번호:</label>
      <input type="password" name="password" id="newPassword" />
      <span class="error" id="pwError"></span>
    </div>

    <div class="form-group">
      <label for="confirmPassword">비밀번호 확인:</label>
      <input type="password" name="confirmPassword" id="confirmPassword" />
      <span class="error" id="confirmError"></span>
    </div>

    <!-- 이름 -->
    <div class="form-group">
      <label>이름:</label>
      <input type="text" value="${loginUser.name}" readonly />
    </div>

    <!-- 이메일 -->
    <div class="form-group">
      <label>이메일:</label>
      <input type="text" name="email" value="${fullUser.email}" />
    </div>

    <!-- 전화번호 -->
    <div class="form-group">
      <label for="phone">전화번호:</label>
      <input type="text" name="phone" id="phone" value="${fullUser.phone}" />
    </div>

    <!-- 수강과목 -->
    <div class="form-group">
      <label>수강과목:</label>
      <input type="text" value="${fullUser.courseName}" readonly />
    </div>

    <!-- 가입일 -->
    <div class="form-group">
      <label>가입일:</label>
      <input type="text" value="${loginUser.regDate}" readonly />
    </div>

    <!-- 제출 버튼 -->
    <div class="form-group">
      <button type="button" id="submitBtn">수정하기</button>
    </div>

  </form>
</div>
</c:if>

<style>
  .form-group {
    margin-bottom: 12px;
  }
  .form-group input {
    padding: 5px;
    width: 200px;
  }
  .error {
    color: red;
    font-size: 12px;
    margin-left: 10px;
  }
</style>

