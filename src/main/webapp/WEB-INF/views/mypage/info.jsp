<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${loginUser.role ne 'admin'}">
<div class="mypage-section">
  <h3>👤 개인정보</h3>
  <form id="updateForm">
    
    <!-- 아이디 -->
    <div class="form-group">
      <label for="userIdInput">아이디:</label>
      <c:choose>
        <c:when test="${loginUser.role eq 'teacher'}">
          <input type="text" id="userIdInput" name="teacherId" class="short-input" value="${loginUser.teacherId}" />
        </c:when>
        <c:when test="${loginUser.role eq 'student'}">
          <input type="text" id="userIdInput" name="studentId" class="short-input" value="${loginUser.studentId}" />
        </c:when>
      </c:choose>
      <button type="button" id="checkBtn" class="submit-btn">중복확인</button>
    </div>

    <!-- 비밀번호 -->
    <!-- 현재 비밀번호 -->
	<div class="form-group">
	  <label for="currentPassword">현재 비밀번호:</label>
	  <input type="password" name="currentPassword" id="currentPassword" class="short-input"/>
	  <span class="error" id="currentPwError"></span>
	</div>
	
    <div class="form-group">
      <label for="newPassword">변경 비밀번호:</label>
      <input type="password" name="password" id="newPassword" class="short-input"/>
      <span class="error" id="pwError"></span>
    </div>

    <div class="form-group">
      <label for="confirmPassword">비밀번호 확인:</label>
      <input type="password" name="confirmPassword" id="confirmPassword" class="short-input"/>
      <span class="error" id="confirmError"></span>
    </div>

    <!-- 이름 -->
    <div class="form-group">
      <label>이름:</label>
      <input type="text" class="short-input" value="${loginUser.name}" readonly />
    </div>

    <!-- 이메일 -->
    <div class="form-group">
      <label>이메일:</label>
      <input type="text" name="email" id="email" class="short-input" value="${fullUser.email}" />
    </div>

    <!-- 전화번호 -->
    <div class="form-group">
      <label for="phone">전화번호:</label>
      <input type="text" name="phone" id="phone" class="short-input" value="${fullUser.phone}" />
    </div>

    <!-- 가입일 -->
    <div class="form-group">
      <label>가입일:</label>
      <input type="text" class="short-input"
         value="<fmt:formatDate value='${loginUser.regDate}' pattern='yyyy-MM-dd HH:mm:ss'/>"
         readonly />
    </div>

    <!-- 제출 버튼 -->
    <div class="form-group">
      <button type="button" id="submitBtn" class="submit-btn">수정하기</button>
    </div>

  </form>
</div>
</c:if>


