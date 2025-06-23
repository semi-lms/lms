<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>학생 등록 페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
}
.container {
    display: flex;
}
.sidebar {
    width: 250px;
    background: #333;
    color: #fff;
    min-height: 100vh;
}
.main {
    flex: 1;
    padding: 40px;
    margin-left: 300px;
}

.student-card {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    padding: 20px;
    margin-bottom: 20px;
    position: relative;
    z-index: 1;
    width: 70%;
}
.remove-row-btn {
    position: absolute;
    top: 10px;
    right: 10px;
    background-color: transparent;  /* 배경 투명 */
    border: 2px solid black;         /* 검정 테두리 */
    color: black;                    /* 글자 검정 */
    font-size: 20px;
    cursor: pointer;
    padding: 0 6px;
    border-radius: 4px;
    line-height: 1;
    transition: background-color 0.3s, color 0.3s;
}

.remove-row-btn:hover {
    background-color: black;         /* hover 시 검정 배경 */
    color: white;                    /* hover 시 글자 흰색 */
    border-color: black;
}
.student-card input {
    width: calc(50% - 10px);
    margin: 5px;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
}
.student-card input[readonly] {
    background: #eee;
}
.btn-area {
    margin: 20px 0;
}
#insertRowBtn, button[type="submit"] {
    padding: 10px 20px;
    border: 2px solid black;
    border-radius: 4px;
    margin-right: 10px;
    cursor: pointer;
    background-color: transparent;
    color: black;
    transition: background-color 0.3s, color 0.3s;
}

#insertRowBtn:hover, button[type="submit"]:hover {
    background-color: black;
    color: white;
    border-color: black;
}

</style>
</head>
<body>
<div class="container">
    <div class="sidebar">
        <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp"/>
    </div>
    <div class="main">
        <h1>학생 등록 페이지</h1>
        <form action="/admin/insertStudent" method="post" onsubmit="return validateForm()">
            <select name="courseId" required>
                <option value="">강의 선택</option>
                <c:forEach var="course" items="${course}">
                    <option value="${course.courseId}">${course.courseName}</option>
                </c:forEach>
            </select>
          
<div id="studentCardContainer">
    <div class="student-card" data-index="0">
        <input type="text" name="studentList[0].name" placeholder="이름">
        <input type="text" name="studentList[0].phone" placeholder="전화번호" class="phone-input">
        <input type="text" name="studentList[0].sn" placeholder="주민번호">
        <input type="text" name="studentList[0].address" placeholder="주소">
        <input type="email" name="studentList[0].email" placeholder="이메일">
        <input type="text" name="studentList[0].studentId" placeholder="초기 아이디" readonly>
        <input type="text" name="studentList[0].password" placeholder="초기 비밀번호" readonly>
    </div>
</div>
            <div class="btn-area">
                <button type="button" id="insertRowBtn">행 추가</button>
                <button type="submit">➕ 등록</button>
            </div>
        </form>
    </div>
</div>

<script>
let rowIdx = 1;

function randomId(length = 6) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    let result = "";
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
}

$(function(){
    $("#insertRowBtn").click(function(){
        const idx = rowIdx++;
        const card = $(`
            <div class="student-card" data-index="${idx}">
                <button type="button" class="remove-row-btn" title="행 삭제">&times;</button>
                <input type="text" name="studentList[${idx}].name" placeholder="이름">
                <input type="text" name="studentList[${idx}].phone" placeholder="전화번호" class="phone-input">
                <input type="text" name="studentList[${idx}].sn" placeholder="주민번호">
                <input type="text" name="studentList[${idx}].address" placeholder="주소">
                <input type="email" name="studentList[${idx}].email" placeholder="이메일">
                <input type="text" name="studentList[${idx}].studentId" placeholder="초기 아이디" readonly>
                <input type="text" name="studentList[${idx}].password" placeholder="초기 비밀번호" readonly>
            </div>
        `);
        $("#studentCardContainer").append(card);
    });

    $("#studentCardContainer").on("click", ".remove-row-btn", function(){
        $(this).closest(".student-card").remove();
    });

    $("#studentCardContainer").on("input", ".phone-input", function(){
        let v = $(this).val().replace(/[^0-9]/g,"");
        let formatted = v;
        if(v.length<4) formatted=v;
        else if(v.length<8) formatted = v.substr(0,3)+"-"+v.substr(3);
        else if(v.length<=11) formatted = v.substr(0,3)+"-"+v.substr(3,4)+"-"+v.substr(7);
        else formatted = v.substr(0,3)+"-"+v.substr(3,4)+"-"+v.substr(7,4);
        $(this).val(formatted);

        const row = $(this).closest(".student-card");
        const num = v;
        if(num.length >= 4){
            row.find("input[name$='.password']").val(num.slice(-4));
            row.find("input[name$='.studentId']").val(randomId());
        } else {
            row.find("input[name$='.password']").val("");
            row.find("input[name$='.studentId']").val("");
        }
    });

    $("#studentCardContainer").on("input", "input[name$='.sn']", function(){
        let v = $(this).val().replace(/[^0-9]/g,"");
        if(v.length<=6) $(this).val(v);
        else if(v.length<=13) $(this).val(v.substr(0,6)+"-"+v.substr(6));
        else $(this).val(v.substr(0,6)+"-"+v.substr(6,7));
    });
});

function validateForm(){
    let valid = true, anyFilled=false;
    $(".student-card").each(function(){
        const inputs = $(this).find("input[type=text]:not([readonly]), input[type=email]");
        let filled=false;
        inputs.each(function(){
            const val = $(this).val().trim();
            if(val) filled=true;
        });
        if(!filled) {
            inputs.removeAttr("name");
            return;
        }
        anyFilled=true;
        inputs.each(function(){
            const $this = $(this);
            const val = $this.val().trim();
            if(!val){
                valid=false;
                $this.css("border","2px solid red");
            } else {
                $this.css("border","");
            }
        });
        const email = $(this).find("input[type=email]").val().trim();
        if(email && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)){
            alert("이메일 형식이 올바르지 않습니다.");
            valid=false;
        }
        const phone = $(this).find(".phone-input").val().replace(/-/g,"");
        if(phone && !/^01[016789][0-9]{7,8}$/.test(phone)){
            alert("전화번호 형식이 올바르지 않습니다.");
            valid=false;
        }
        const sn = $(this).find("input[name$='.sn']").val().trim();
        if(sn && !/^[0-9]{6}-?[0-9]{7}$/.test(sn)){
            alert("주민번호 형식이 올바르지 않습니다.");
            valid=false;
        }
    });
    if(!anyFilled){
        alert("최소 1명의 학생 정보를 모두 입력하세요.");
        return false;
    }
    return valid;
}
</script>
</body>
</html>
