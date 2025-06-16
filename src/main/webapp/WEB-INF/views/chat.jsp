<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WebSocketTest- chat</title>
<link rel="stylesheet" href="https://me2.do/5BvBFJ57">
<style>
html, body {
    padding: 0 !important;
    margin: 0 !important;
    background-color: #FFF !important; 
    display: block;
    overflow: hidden;
}

body > div {
    margin: 0; 
    padding: 0; 
}

#main {
    width: 400px;
    height: 510px;
    margin: 3px;
    display: grid;
    grid-template-rows: repeat(12, 1fr);
}
#header > h2 {        
    margin: 0px;
    margin-bottom: 10px;
    padding: 5px;
}

#list {
    border: 1px solid var(--border-color);
    box-sizing: content-box;
    padding: .5rem;
    grid-row-start: 2;
    grid-row-end: 12;
    font-size: 14px;
    overflow: auto;
    color: #000 !important; /* 텍스트 색상 검정으로 명확히 */
}

#msg {
    margin-top: 3px;
}

#list .item {
    font-size: 14px;
    margin: 15px 0;
}

#list .item > div:first-child {
    display: flex;
}

#list .item.me > div:first-child {
    justify-content: flex-end;
}

#list .item.other > div:first-child {
    justify-content: flex-end;
    flex-direction: row-reverse;
}

#list .item > div:first-child > div:first-child {
    font-size: 10px;
    color: #777;
    margin: 3px 5px;
}

#list .item > div:first-child > div:nth-child(2) {
    border: 1px solid var(--border-color);
    display: inline-block;
    min-width: 100px;
    max-width: 250px;
    text-align: left;
    padding: 3px 7px;
    color: #000 !important; /* 메시지 내용 색상 명확히 */
    background-color: #eee !important;
}

#list .state.item > div:first-child > div:nth-child(2) {
    background-color: #EEE;
}

#list .item > div:last-child {
    font-size: 10px;
    color: #777;
    margin-top: 5px;
}

#list .me {
    text-align: right;
}

#list .other {
    text-align: left;
}

#list .msg.me.item > div:first-child > div:nth-child(2) {
    background-color: rgba(255, 99, 71, .2);
}

#list .msg.other.item > div:first-child > div:nth-child(2) {
    background-color: rgba(100, 149, 237, .2);
}

#list .msg img {
    width: 150px;
}
</style>
</head>
<body>
    <!-- chat.jsp  -->
    
    <div id="main">
        <div id="header"><h2>WebSocket <small>닉네임</small></h2></div>
        <div id="list"></div>
        <input type="text" id="msg" placeholder="대화 내용을 입력하세요.">
    </div>
    
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>

<script>
    let name;
    let ws;
    const url = 'ws://localhost:80/socket/chatserver.do';

    window.onload = function() {
        name = prompt("닉네임을 입력하세요:");
        window.name = name;
        connect();
    };

    function connect() {
        ws = new WebSocket(url);

        ws.onopen = function() {
            console.log("WebSocket 연결됨");
            // 입장 알림 보내기
            let message = {
                code: '1',
                sender: window.name,
                receiver: '',
                content: '',
                regdate: new Date().toLocaleString()
            };
            if (ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify(message));
            }
        };

        ws.onmessage = function(evt) {
            let message = JSON.parse(evt.data);
            console.log('받은 메시지:', message);
            if (message.code === '1') {
                print('', `[${message.sender}]님이 들어왔습니다.`, 'other', 'state', message.regdate);
            } else if (message.code === '2') {
                print('', `[${message.sender}]님이 나갔습니다.`, 'other', 'state', message.regdate);
            } else if (message.code === '3') {
                print(message.sender, message.content, 'other', 'msg', message.regdate);
            }
        };

        ws.onclose = function() {
            console.log("WebSocket 연결 종료됨");
        };

        ws.onerror = function(err) {
            console.error("WebSocket 오류:", err);
        };
    }

    $('#msg').keydown(function(evt) {
        if (evt.keyCode === 13) { // 엔터
            let message = {
                code: '3',
                sender: window.name,
                receiver: '',
                content: $('#msg').val(),
                regdate: new Date().toLocaleString()
            };

            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify(message));
                print(window.name, message.content, 'me', 'msg', message.regdate);
                $('#msg').val('').focus();
            } else {
                alert('서버와 연결이 끊어졌습니다. 새로고침 해주세요.');
            }
        }
    });

    function escapeHtml(text) {
        return text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    function print(name, msg, side, state, time) {
        let safeMsg = escapeHtml(msg || '(빈 메시지)');
        let temp = `
            <div class="item ${state} ${side}">
                <div>
                    <div>${escapeHtml(name)}</div>
                    <div>${safeMsg}</div>
                </div>
                <div>${time}</div>
            </div>`;
        $('#list').append(temp);
        scrollList();
    }

    function scrollList() {
        $('#list').scrollTop($('#list')[0].scrollHeight);
    }

    $(window).on('beforeunload', function() {
        disconnect();
    });

    function disconnect() {
        if (ws && ws.readyState === WebSocket.OPEN) {
            let message = {
                code: '2',
                sender: window.name,
                receiver: '',
                content: '',
                regdate: new Date().toLocaleString()
            };
            ws.send(JSON.stringify(message));
        }
    }
</script>
</body>
</html>
