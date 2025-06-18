package com.example.lms.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.FileBoardDTO;
import com.example.lms.dto.FileDTO;
import com.example.lms.dto.Page;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.mapper.FileMapper;
import com.example.lms.service.AdminService;
import com.example.lms.service.FileBoardService;
import com.example.lms.service.FileService;

import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping("/file")
public class FileBoardController {

	@Autowired
	private FileBoardService fileBoardService;
	@Autowired
	private PasswordEncoder passwordEncoder; // 암호화 필드 받기 // com.example.lms.config.SecurityConfig
	@Autowired
	private AdminService adminService;
	@Autowired
	private FileService fileService;
	@Autowired
	private FileMapper fileMapper;
	
	
	// 자료실 리스트
		@GetMapping("/fileBoardList")
		   public String fileBoardList (Model model,
		            @RequestParam(defaultValue = "1") int currentPage,
		            @RequestParam(value="searchOption", required=false, defaultValue="all") String searchOption,
					@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
		   			@RequestParam(defaultValue = "10") int rowPerPage) {
				
				int totalCount = fileBoardService.totalCount(searchOption, keyword);
			    Page page = new Page(rowPerPage, currentPage, totalCount, searchOption, keyword);
				int startRow = (currentPage - 1) * rowPerPage;
		        
		        Map<String, Object> param = new HashMap<>();
		        param.put("searchOption", searchOption);
		        param.put("keyword", keyword);
		        param.put("startRow", (currentPage - 1) * rowPerPage);
		        param.put("rowPerPage", rowPerPage);

		        List<FileBoardDTO> fileBoardList = fileBoardService.selectFileBoardList(param);

		        // 페이징 계산
		        int lastPage = (int) Math.ceil((double) totalCount / rowPerPage);
		        int pageSize = 10;
		        int startPage = ((currentPage - 1) / pageSize) * pageSize + 1;
		        int endPage = Math.min(startPage + pageSize - 1, lastPage);
		        
		        
		        model.addAttribute("fileBoardList", fileBoardList);
		        model.addAttribute("currentPage", currentPage);
		        model.addAttribute("searchOption", searchOption);
		        model.addAttribute("keyword", keyword);
		        model.addAttribute("rowPerPage", rowPerPage);
		        model.addAttribute("startPage", startPage);
		        model.addAttribute("endPage", endPage);
		        model.addAttribute("lastPage", lastPage);
		        

		        return"file/fileBoardList";
		    }
		
		// 작성
		@GetMapping("/insertFileBoard")
		public String insertFileBoard() {
			// 작성하는페이지로 이동
			// 제목, 내용 입력창
			return "file/insertFileBoard";
		}
		
		// 게시글 + 파일 등록 처리
		@PostMapping("/insertFileBoard")
		public String insertFileBoard(@ModelAttribute FileBoardDTO fileBoardDto,
									  @RequestParam("uploadFile") MultipartFile[] uploadFiles,
									  HttpSession session,
									  RedirectAttributes ra) {		
			
			SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");		// 현재 로그인한 사용자 정보를 세션에서 꺼냄
			
			fileBoardDto.setAdminId(loginUser.getAdminId());		// 로그인 정보에서 adminId 가져오기
			
			fileBoardService.insertFileBoard(fileBoardDto);		// 게시글 DB에 저장 요청
			
			// 파일이 업로드 된 경우
			for (MultipartFile uploadFile : uploadFiles) {
			if(uploadFile != null && !uploadFile.isEmpty()) {
				try {
					// 파일 원본명
					String originalFilename = uploadFile.getOriginalFilename();
					
					// 저장할 이름 (UUID + 원본 확장자)
					String ext = StringUtils.getFilenameExtension(originalFilename);
					String uuidName = UUID.randomUUID().toString().replace("-", "") + "." + ext;
					
					// 저장경로 (운영 시에는 외부경로 추천)
					String uploadDir = "C:/upload/";
					File dir = new File(uploadDir);
					if (!dir.exists()) dir.mkdirs();
					
					// 실제 파일 저장
					File saveFile = new File(uploadDir + uuidName);
					uploadFile.transferTo(saveFile);
					
					// 파일 정보 DB에 저장
					FileDTO fileDto = new FileDTO();
					fileDto.setFileBoardNo(fileBoardDto.getFileBoardNo());
					fileDto.setAdminId(loginUser.getAdminId());
					fileDto.setFileName(originalFilename);	// 사용자에게 보여줄 이름
					fileDto.setFilePath("C:/upload/" + uuidName);	// 웹에서 접근할 경로
					fileDto.setSaveName(uuidName);
					
					fileMapper.insertFile(fileDto);
					
	            } catch (IOException e) {
	                e.printStackTrace();
	                ra.addFlashAttribute("errorMsg", "파일 업로드 실패");
	                return "redirect:/file/insertFileBoard";
	            }
	        }
		 }
			
			return "redirect:/file/fileBoardList";		// 작성 후 리다이렉트로 공지사항리스트로
		}
		
		// 상세보기
		@GetMapping("/fileBoardOne")
		public String fileBoardOne(@RequestParam("fileBoardNo") int fileBoardNo, Model model) {
			
			// DB에서 noticeNo와 일치하는 행을 조회하여 DTO에 담아 반환
			FileBoardDTO fileBoardDto = fileBoardService.selectFileBoardOne(fileBoardNo);
			List<FileDTO> fileList = fileService.selectFileListByBoardNo(fileBoardNo);
			model.addAttribute("fileBoard", fileBoardDto);
			model.addAttribute("fileList", fileList);
			
			return"file/fileBoardOne";
		}
		
		// 수정
		@GetMapping("/updateFileBoard")
		public String updateFileBoard(@RequestParam("fileBoardNo") int fileBoardNo, Model model) {
			// 기존 공지사항 정보 가져오기
			FileBoardDTO fileBoard = fileBoardService.selectFileBoardOne(fileBoardNo);
			
			// 해당 게시물의 첨부파일 리스트 가져오기
			List<FileDTO> fileList = fileService.selectFileListByBoardNo(fileBoardNo);
			model.addAttribute("fileBoard", fileBoard);
			model.addAttribute("fileList", fileList);
			return "file/updateFileBoard";
		}
		
		@PostMapping("/updateFileBoard")
		public String updateFileBoard(@ModelAttribute FileBoardDTO fileBoardDto,
									  @RequestParam(value = "deleteFileNames", required = false) List<String> deleteFileNames,
					                  @RequestParam(value = "uploadFile", required = false) MultipartFile[] uploadFiles,
					                  HttpSession session,
					                  RedirectAttributes ra) {
			// 1. 게시글 수정
		    fileBoardService.updateFileBoard(fileBoardDto);

		    // 2. 기존 파일 삭제
		    if (deleteFileNames != null) {
		        for (String saveName : deleteFileNames) {
		        	fileService.deleteFileBySaveName(saveName);
		        }
		    }

		    // 3. 새로운 파일 업로드 처리
		    SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");

		    if (uploadFiles != null && uploadFiles.length > 0) {
		        for (MultipartFile uploadFile : uploadFiles) {
		            if (!uploadFile.isEmpty()) {
		                try {
		                    // 3-1. 원본 파일명
		                    String originalFilename = uploadFile.getOriginalFilename();

		                    // 3-2. 저장할 파일명 (UUID)
		                    String ext = org.springframework.util.StringUtils.getFilenameExtension(originalFilename);
		                    String uuidName = java.util.UUID.randomUUID().toString().replace("-", "") + "." + ext;

		                    // 3-3. 저장 경로
		                    String uploadDir = "C:/upload/";
		                    File dir = new File(uploadDir);
		                    if (!dir.exists()) dir.mkdirs();

		                    // 3-4. 파일 저장
		                    File saveFile = new File(uploadDir + uuidName);
		                    uploadFile.transferTo(saveFile);

		                    // 3-5. DB 저장용 정보 구성
		                    FileDTO fileDto = new FileDTO();
		                    fileDto.setFileBoardNo(fileBoardDto.getFileBoardNo());
		                    fileDto.setAdminId(loginUser.getAdminId());
		                    fileDto.setFileName(originalFilename);
		                    fileDto.setSaveName(uuidName);
		                    fileDto.setFilePath("C:/upload/" + uuidName);

		                    // 3-6. DB에 저장
		                    fileMapper.insertFile(fileDto);

		                } catch (Exception e) {
		                    e.printStackTrace();
		                    ra.addFlashAttribute("errorMsg", "파일 업로드 중 오류 발생");
		                }
		            }
		        }
		    }

		    // 4. 수정 완료 후 상세보기 페이지로 이동
		    return "redirect:/file/fileBoardOne?fileBoardNo=" + fileBoardDto.getFileBoardNo();
		}
		
		// 삭제
		@PostMapping("/deletefileBoard")
		public String deleteFileBoard(@RequestParam int fileBoardNo,
		                              @RequestParam String pw,
		                              HttpSession session,
		                              RedirectAttributes ra) {

		    // 로그인한 관리자 세션 정보 가져오기
		    SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");

		    // 로그인 안 되어 있으면 로그인 페이지로
		    if (loginUser == null || loginUser.getAdminId() == null) {
		        ra.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
		        return "redirect:/login";
		    }

		    // 1. 로그인한 관리자 정보 DB에서 조회
		    AdminDTO admin = adminService.getAdminById(loginUser.getAdminId());

		    // 2. 비밀번호 일치 검사
		    if (!passwordEncoder.matches(pw, admin.getPassword())) {
		        ra.addFlashAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
		        return "redirect:/file/fileBoardOne?fileBoardNo=" + fileBoardNo;
		    }

		    // 3. 삭제 수행
		    fileBoardService.deleteFileBoard(fileBoardNo);

		    return "redirect:/file/fileBoardList";
		}
		
		// 파일 다운로드
		@GetMapping("/download")
		public ResponseEntity<Resource> downloadFile(@RequestParam String saveName) throws IOException {
			    // uploadPath: 실제 서버에 파일이 저장된 디렉토리
			    String uploadPath = "C:/upload/";

			    // fileName = 실제 저장된 이름(UUID)
			    FileDTO file = fileService.selectFileBySaveName(saveName);
			    if (file == null) {
			    	  System.out.println("DB에 해당 파일 없음: " + saveName);
			    	  
			        throw new FileNotFoundException("DB에서 해당 파일 정보를 찾을 수 없습니다: " + saveName);
			    }

			    String originalName = file.getFileName(); // 브라우저에 표시할 원래 이름
			    Path filePath = Paths.get(file.getFilePath()).normalize(); // DB에 저장된 전체 경로 그대로 사용
			    System.out.println("파일 경로: " + filePath);
			    
			    Resource resource = new UrlResource(filePath.toUri());
			    
			    System.out.println("실제 파일 경로: " + filePath);

			    if (!resource.exists()) {
			    	System.out.println("실제 파일이 존재하지 않음: " + filePath);
			    	
			        throw new FileNotFoundException("파일이 존재하지 않습니다.");
			    }

			    // 한글 파일 이름 깨짐 방지 (브라우저 호환을 위해 URL 인코딩)
			    String encodedFileName = URLEncoder.encode(originalName, StandardCharsets.UTF_8)
			                                       .replaceAll("\\+", "%20");

			    // Content-Disposition 헤더에 원래 이름으로 설정
			    return ResponseEntity.ok()
			        .contentType(MediaType.APPLICATION_OCTET_STREAM)
			        .header(HttpHeaders.CONTENT_DISPOSITION,
			                "attachment; filename=\"" + encodedFileName + "\"")
			        .body(resource);
			}
		
		
		@PostMapping("/upload")
		public String uploadFile(@RequestParam MultipartFile file) throws IOException {
		    String uploadPath = "C:/upload/";
		    File dir = new File(uploadPath);
		    if (!dir.exists()) {
		        dir.mkdirs(); // 폴더가 없으면 생성
		    }
		    System.out.println("운영체제: " + System.getProperty("os.name"));
		    String originalName = file.getOriginalFilename(); 
		    String saveName = UUID.randomUUID().toString() + "_" + originalName; // 확장자 포함 저장
		    File saveFile = new File("C:/upload/" + saveName);
		    file.transferTo(saveFile);
		    System.out.println("파일 실제 저장됨: " + saveFile.getAbsolutePath());
		    // DTO에 정보 설정
		    FileDTO dto = new FileDTO();
		    dto.setFileName(originalName);        // 사용자에게 보이는 원래 이름
		    dto.setSaveName(saveName);            // 저장된 이름
		    dto.setFilePath("C:/upload/" + saveName); // 절대경로로 저장
		    dto.setUploadDate(Timestamp.valueOf(LocalDateTime.now())); // 업로드 시간
		    System.out.println(">> 저장될 filePath: " + dto.getFilePath());
		    fileService.insertFile(dto);
		    return "redirect:/success";
		}
		
		
}
