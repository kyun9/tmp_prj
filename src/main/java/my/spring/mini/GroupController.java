package my.spring.mini;

import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import dao.FieldDAO;
import dao.GroupDAO;
import dao.Users_GroupDAO;
import service.ImageUploadService;
import vo.GroupVO;
import vo.Group_InfoVO;
import vo.Login_InfoVO;

@Controller
public class GroupController {
	@Autowired
	FieldDAO Fielddao;
	@Autowired
	GroupDAO GroupDao;
	@Autowired
	Users_GroupDAO ugDAO;
	@Autowired
	private ImageUploadService imageUploadService;
	
	
	@RequestMapping(value="/group",  method = RequestMethod.GET)
	public ModelAndView group(String action, String field,String key) {
		ModelAndView mav = new ModelAndView();

		mav.addObject("field", Fielddao.ListAllType());
		if (action != null) {
			if (action.equals("search")) {
				mav.addObject("grouplist", GroupDao.search(key, field));
				mav.setViewName("group/group");
				return mav;
			}
		}
		mav.addObject("grouplist", GroupDao.ListAllGroup());
		mav.setViewName("group/group");
		return mav;		
	}
	
	@RequestMapping(value="/group/createGroup", method = RequestMethod.GET)
	public ModelAndView doGetCreatGroup() {
		ModelAndView mav = new ModelAndView();
		mav.addObject("field", Fielddao.ListAllType());
		mav.setViewName("group/gEdit");
		return mav;
	}
	
	@RequestMapping(value="/group/createGroup", method = RequestMethod.POST)
	public ModelAndView doPostCreatGroup(GroupVO vo, String action, MultipartFile image) throws IOException {
		ModelAndView mav = new ModelAndView();
		if (action.equals("insert")) {
			vo.setImg(image.getOriginalFilename());
			imageUploadService.getImagePath(image);
			boolean result = GroupDao.create(vo);
			if(result) 
				System.out.println("그룹 생성 성공");
			else
				System.out.println("그룹 생성 실패");
		}
		mav.setViewName("redirect:/group");
		return mav;
	}
	
	@RequestMapping(value="/group/content", method =RequestMethod.GET)
	public ModelAndView showContent(int gid, String action,String uid, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		Login_InfoVO user = (Login_InfoVO) session.getAttribute("loginUser");
		if(action!=null) {
			if(action.equals("apply")) {
				if(!ugDAO.applyGroup(uid,gid)) { 
					mav.addObject("msg", "이미 그룹 가입 신청하였습니다.");
				}
				else {
					mav.addObject("msg", "가입 신청하였습니다.");
				}
			}
		}
		if(session.getAttribute("loginUser")!=null) {
		if(ugDAO.statusJoin(user.getUser(),gid)) {
			mav.addObject("confirm", "나의 그룹");
		}}
		Group_InfoVO vo =GroupDao.showContent(gid);
		mav.addObject("content", vo);
		mav.setViewName("group/content");
		return mav;
	}
	
	@RequestMapping(value="/group/manage",method=RequestMethod.GET)
	public ModelAndView manageGroup(int gid, String action,String uid) {
		ModelAndView mav = new ModelAndView();
		String url="group/manage";
		if(action!=null) {
			if(action.equals("welcomeApplicant")) {
				ugDAO.acceptMember(gid,uid);
				}
			else if(action.equals("rejectApplicant")) {
				ugDAO.rejectMember(gid,uid);
			}
			url="redirect:/group/manage?gid="+gid;
		}
		mav.addObject("tempMember", ugDAO.tempMember(gid));
		mav.addObject("currentMember", ugDAO.currentMember(gid));
		mav.setViewName(url);
		return mav;
	}
	
	
}
