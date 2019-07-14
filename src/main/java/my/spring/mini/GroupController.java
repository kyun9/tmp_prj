package my.spring.mini;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import dao.FieldDAO;

@Controller
public class GroupController {
	@Autowired
	FieldDAO Fielddao;
	
	@RequestMapping(value="/group")
	public ModelAndView group() {
		ModelAndView mav = new ModelAndView();
		mav.addObject("field", Fielddao.ListAllType());
		mav.setViewName("group/group");
		return mav;		
	}
	
	@RequestMapping(value="/group/createGroup")
	public ModelAndView creatGroup() {
		return null;
	}
	
}
