package com.example.lms.config;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Component;

import com.example.lms.dto.MessageDTO;
import com.google.gson.Gson;

import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
@Component
@ServerEndpoint("/socket/chatserver.do")
public class ChatServer {

	private static List<Session> sessionList = new ArrayList<Session>();
	
	@OnOpen
	public void handleOpen(Session session) {
		sessionList.add(session);
		checkSessionList();			//접속자 확인
		clearSessionList();			
	}
	
	@OnMessage
	public void handleMessage(String msg, Session session) {
		System.out.println(msg);
		
		Gson gson = new Gson();
		
	 	MessageDTO message =  gson.fromJson(msg, MessageDTO.class);
		if (message.getCode().equals("1")) { //상대방 대화방 입장
	 		for (Session s : sessionList) {
	 			if (s != session) {
	 				try {
	 					s.getBasicRemote().sendText(msg);
					} catch (Exception e) {
						e.printStackTrace();
					}
	 			}
	 		}
	 	} else if (message.getCode().equals("2")) { 
	 		sessionList.remove(session);
	 		for (Session s : sessionList) {
	 			try {
	 				s.getBasicRemote().sendText(msg);
				} catch (Exception e) {
					e.printStackTrace();
				}
	 		}
	 	} else if (message.getCode().equals("3")) {	
	 		//보낸 사람빼고 나머지 사람에게 전달한다.
	 		for (Session s : sessionList) {
	 			if (s != session) {
	 				try {
						s.getBasicRemote().sendText(msg);
					} catch (Exception e) {
						e.printStackTrace();
					}
	 			}
	 		}
	 		
	 	} 
	}
	
	//접속자를 확인하는 메서드
	private void checkSessionList() {
		System.out.println();
		System.out.println("[Session List]");
		for (Session session : sessionList) {
			System.out.println(session.getId());
		}
		System.out.println();
	}
	
	//안정성을 위한 메서드 : 연결이 끊어진 세션이 있으면 세션리스트에서 제거한다.
	private void clearSessionList() {
		
		//List 계열의 컬렉션은 향상된 for문 내에서 요소 추가/삭제하는 행동을 할 수 없다.
		//가능한 방법은 1. 일반 forans, 2. Interator 방법이 있다.
		Iterator<Session> iter = sessionList.iterator();
		
		while(iter.hasNext()) {
			if(!(iter.next()).isOpen()) {
				//혹시 연결이 끊어진 세션이 있으면 리스트에서 제거한다.
				iter.remove();
			}
		}
		
	}
	
}
