<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
   <title>로그인</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .login-container {
            max-width: 500px;
            margin: 100px auto;
        }
        .card {
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .btn-group-custom {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container login-container">
    <div class="card">
            <h4 class="mb-4 text-center">로그인</h4>
            <form action="login" method="post">
                <div class="mb-3">
                    <label for="id" class="form-label">ID</label>
                    <input type="text" class="form-control" id="id" name="id" required>
                </div>
                <div class="mb-3">
                    <label for="pw" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="pw" name="pw" required>
                </div>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <div class="d-grid gap-2 mt-3">
                    <button type="submit" class="btn btn-primary">로그인</button>
                </div>
                
                <!-- 사용자 타입 선택 -->
				<div class="mb-3 text-center">
				    <div class="btn-group" role="group">
				        <input type="radio" class="btn-check" name="role" id="admin" value="admin" autocomplete="off" required>
				        <label class="btn btn-outline-danger" for="admin">관리자</label>
				
				        <input type="radio" class="btn-check" name="role" id="teacher" value="teacher" autocomplete="off">
				        <label class="btn btn-outline-warning" for="teacher">강사</label>
				
				        <input type="radio" class="btn-check" name="role" id="student" value="student" autocomplete="off">
				        <label class="btn btn-outline-success" for="student">학생</label>
				    </div>
			   </div>
            
        </form>
    </div>
</div>

</head>
</body>
</html>