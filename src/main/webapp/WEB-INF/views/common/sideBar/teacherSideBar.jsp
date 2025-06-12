<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div style="border: 2px solid #ddd; padding: 10px; padding-top: 30px; border-radius: 15px;
            width: 250px; height: 700px; background-color: #fff; box-shadow: 2px 2px 10px rgba(0,0,0,0.1); text-align: center;">
    
    <p style="font-size: 18px;"><strong>${loginUser.name}</strong> 님</p>
    <p style="margin-bottom: 10px;">마이페이지</p>

    <button style="font-size: 20px;">🏠 홈</button>

    <a href="/mypage/info"><button>개인정보</button></a><br><br>
    <a href="/mypage/attendance"><button>강의목록</button></a><br><br>
    <a href="/mypage/courses"><button>관리목록</button></a><br><br>
    <a href="/mypage/exam"><button>시험문제</button></a><br><br>
    <a href="/mypage/schedule"><button>강의일정</button></a><br><br>
    <a href="/mypage/schedule"><button>공지사항</button></a><br><br>
    <a href="/qna"><button>QNA</button></a><br><br>
    <a href="/fileBoard"><button>자료실</button></a><br><br>
    <a href="/logout"><button>로그아웃</button></a>
</div>