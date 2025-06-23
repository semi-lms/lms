package com.example.lms.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.*;
import com.example.lms.service.*;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/file")
public class FileBoardController {

    @Autowired private FileBoardService fileBoardService;		// 게시글 관련 서비스
    @Autowired private PasswordEncoder passwordEncoder;			// 비밀번호 암호화 검사용
    @Autowired private AdminService adminService;				// 관리자 정보 조회용
    @Autowired private FileService fileService;					// 파일 처리 서비스

    // 자료실 리스트
    @GetMapping("/fileBoardList")
    public String fileBoardList(Model model,
                                 @RequestParam(defaultValue = "1") int currentPage,			// 현재 페이지
                                 @RequestParam(defaultValue = "all") String searchOption,	// 검색 옵션 (제목, 내용 등)
                                 @RequestParam(defaultValue = "") String keyword,			// 검색어
                                 @RequestParam(defaultValue = "10") int rowPerPage) {		// 페이지당 글 수

    	// 전체 게시글 수 계산
        int totalCount = fileBoardService.totalCount(searchOption, keyword);
        
        // 페이지 계산 객체 생성
        Page page = new Page(rowPerPage, currentPage, totalCount, searchOption, keyword);

        // db 조회 맵
        Map<String, Object> param = new HashMap<>();
        param.put("searchOption", searchOption);
        param.put("keyword", keyword);
        param.put("startRow", (currentPage - 1) * rowPerPage);
        param.put("rowPerPage", rowPerPage);

        // 게시글 목록 가져오기
        List<FileBoardDTO> fileBoardList = fileBoardService.selectFileBoardList(param);

        //JSP에 전달할 데이터
        model.addAttribute("fileBoardList", fileBoardList);
        model.addAttribute("page", page);

        return "file/fileBoardList";		// JSP 페이지 이름 반환
    }

    // 게시글 작성 폼 이동
    @GetMapping("/insertFileBoard")
    public String insertFileBoard() {
        return "file/insertFileBoard";
    }
    
    
    // 게시글 + 파일 등록
    @PostMapping("/insertFileBoard")
    public String insertFileBoard(@ModelAttribute FileBoardDTO fileBoardDto,
                                  @RequestParam(value = "uploadFile", required = false) MultipartFile[] uploadFiles,		// 업로드 된 파일들
                                  HttpSession session, RedirectAttributes ra) {

    	// 로그인한 관리자 정보 가져오기
        SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
        
        // 게시글 작성자 ID 설정
        fileBoardDto.setAdminId(loginUser.getAdminId());
        
        // 게시글 db에 저장
        fileBoardService.insertFileBoard(fileBoardDto);

        // 파일이 존재할 경우 처리
        if (uploadFiles != null && uploadFiles.length > 0) {

            // 운영체제별 경로 설정
        	String os = System.getProperty("os.name").toLowerCase();
        	String uploadDir = os.contains("win") ? "C:/upload/" : "/home/ubuntu/upload/";

            // 디렉토리 없으면 생성
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            // 업로드된 각 파일 처리
            for (MultipartFile mf : uploadFiles) {
                if (mf.isEmpty()) continue;
                    try {
                        // 1. 원본 파일명
                        String originalFileName = mf.getOriginalFilename();

                        // 2. UUID로 중복 방지한 저장 이름 생성
                        String uuid = UUID.randomUUID().toString();
                        String saveName = uuid + "_" + originalFileName;

                        // 3. 저장 경로 설정
                        String savePath = uploadDir + saveName;
                        File dest = new File(savePath);
                        mf.transferTo(dest); // 파일 실제 저장
                    	
                    	// dto 구성
                        FileDTO fileDto = new FileDTO();	// 파일 객체 새성
                        fileDto.setFileBoardNo(fileBoardDto.getFileBoardNo());	// 게시글 번호 설정
                        fileDto.setAdminId(loginUser.getAdminId());		// 업로더 ID 설정
                        fileDto.setFileName(mf.getOriginalFilename());	// 원본 파일명
                        fileDto.setFileType(mf.getContentType());		// 어떤 형식의 파일인지
                        fileDto.setFileSize(mf.getSize());				// 파일 크기
                        fileDto.setSaveName(saveName);             // UUID 저장 이름
                        fileDto.setFilePath(savePath);             // 실제 저장 경로
                        
                        // db에 저장
                        fileService.saveFile(fileDto);

                    } catch (IOException e) {
                        e.printStackTrace();
                        ra.addFlashAttribute("errorMsg", "파일 업로드 실패");
                        return "redirect:/file/insertFileBoard";
                    }
                }
            }

        return "redirect:/file/fileBoardList";
    }

    // 상세보기
    @GetMapping("/fileBoardOne")
    public String fileBoardOne(@RequestParam("fileBoardNo") int fileBoardNo, Model model) {
    	
    	// 게시글 정보 조회
        FileBoardDTO fileBoardDto = fileBoardService.selectFileBoardOne(fileBoardNo);
        
        // 해당 게시글에 첨부된 파일 리스트 조회
        List<FileDTO> fileList = fileService.getFilesByBoardNo(fileBoardNo);
        
        model.addAttribute("fileBoard", fileBoardDto);		// 게시글 전달
        model.addAttribute("fileList", fileList);			// 파일 리스트 전달
        return "file/fileBoardOne";
    }
    
    // 수정 (폼으로 이동)
    @GetMapping("/updateFileBoard")
    public String updateFileBoard(@RequestParam("fileBoardNo") int fileBoardNo, Model model) {
    	
    	// 게시글과 첨부파일 조회
        FileBoardDTO fileBoardDto = fileBoardService.selectFileBoardOne(fileBoardNo);
        List<FileDTO> fileList = fileService.getFilesByBoardNo(fileBoardNo);
        
        model.addAttribute("fileBoard", fileBoardDto);
        model.addAttribute("fileList", fileList);
        
        return "file/updateFileBoard"; // JSP 파일 필요
        
    }
    // 수정 처리(파일 추가/삭제 포함)
    @PostMapping("/updateFileBoard")
    public String updateFileBoard(@ModelAttribute FileBoardDTO fileBoardDto,
                                  @RequestParam(value = "uploadFile", required = false) MultipartFile[] uploadFiles,
                                  @RequestParam(value = "deleteFileIds", required = false) List<Integer> deleteFileIds,
                                  HttpSession session, RedirectAttributes ra) {

    	// DB에있는 게시글 수정
        fileBoardService.updateFileBoard(fileBoardDto);

        // 로그인 정보
        SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
        
        // 2. 삭제 체크된 파일 삭제
        if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
            for (Integer fileId : deleteFileIds) {
                fileService.deleteFileById(fileId);  // 해당 파일 삭제
            }
        }
        
        // 새로운 첨부된 파일 처리
        if (uploadFiles != null) {
            for (MultipartFile mf : uploadFiles) {
                if (!mf.isEmpty()) {
                    try {
                    	 // 1. 원본 파일명
                        String originalFileName = mf.getOriginalFilename();

                        // 2. UUID를 이용한 저장 이름
                        String uuid = UUID.randomUUID().toString();
                        String saveName = uuid + "_" + originalFileName;

                     // 3. 저장 경로 설정 (운영체제별 분기)
                        String os = System.getProperty("os.name").toLowerCase();
                        String uploadDir = os.contains("win") ? "C:/upload/" : "/home/ubuntu/upload/";
                        String savePath = uploadDir + saveName;

                        // 4. 실제 파일 저장
                        File dest = new File(savePath);
                        mf.transferTo(dest);
                        System.out.println("파일 저장 완료: " + dest.getAbsolutePath());

                        // 5. DTO 구성
                        FileDTO fileDto = new FileDTO();
                        fileDto.setFileBoardNo(fileBoardDto.getFileBoardNo());
                        fileDto.setAdminId(loginUser.getAdminId());
                        fileDto.setFileName(originalFileName);
                        fileDto.setFileType(mf.getContentType());
                        fileDto.setFileSize(mf.getSize());
                        fileDto.setSaveName(saveName);
                        fileDto.setFilePath(savePath);

                        // 6. DB 저장
                        fileService.saveFile(fileDto);
                    
                    } catch (IOException e) {
                        e.printStackTrace();
                        ra.addFlashAttribute("errorMsg", "파일 업로드 실패");
                    }
                }
            }
        }

        return "redirect:/file/fileBoardOne?fileBoardNo=" + fileBoardDto.getFileBoardNo();
    }

    // 삭제 ( 비밀번호 확인 포함)
    @PostMapping("/deletefileBoard")
    public String deleteFileBoard(@RequestParam int fileBoardNo, 
    							  @RequestParam String pw,
                                  HttpSession session,
                                  RedirectAttributes ra) {

    	// 로그인 확인
        SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
        
        if (loginUser == null || loginUser.getAdminId() == null) {
            ra.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
            
            return "redirect:/login";
        }

        // 관리자 정보 조회
        AdminDTO admin = adminService.getAdminById(loginUser.getAdminId());
        
        // 비밀번호 일치 확인
        if (!passwordEncoder.matches(pw, admin.getPassword())) {
            ra.addFlashAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
            
            return "redirect:/file/fileBoardOne?fileBoardNo=" + fileBoardNo;
        }

        // 게시글과 연관된 모든 파일 삭제 (서비스 내부에서 처리)
        fileBoardService.deleteFileBoard(fileBoardNo);
        
        return "redirect:/file/fileBoardList";
    }
    
    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam String fileName) throws IOException {
        String os = System.getProperty("os.name").toLowerCase();
        String uploadPath = os.contains("win") ? "C:/upload/" : "/home/ubuntu/upload/";

        Path path = Paths.get(uploadPath + fileName);
        if (!Files.exists(path)) {
            throw new FileNotFoundException("파일이 존재하지 않습니다.");
        }

        Resource resource = new UrlResource(path.toUri());
        String encodedName = URLEncoder.encode(fileName, StandardCharsets.UTF_8);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedName + "\"")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(resource);
    }
}
