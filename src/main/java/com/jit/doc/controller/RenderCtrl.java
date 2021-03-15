package com.jit.doc.controller;

import com.jit.doc.dto.GroupDto;
import com.jit.doc.dto.UserDto;
import com.jit.doc.po.Document;
import com.jit.doc.po.Group;
import com.jit.doc.po.GroupMembers;
import com.jit.doc.po.User;
import com.jit.doc.services.DocumentService;
import com.jit.doc.services.GroupService;
import com.jit.doc.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/render")
public class RenderCtrl extends BaseCtrl{
    @Autowired
    private UserService userService;
    @Autowired
    private GroupService groupService;
    @Autowired
    private DocumentService documentService;
    @GetMapping("/common/toLogin")
    public ModelAndView toLogin(HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("common/login");
        return modelAndView;
    }
    @GetMapping("/common/toRegister")
    public ModelAndView toRegister(HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("common/register");
        return modelAndView;
    }
    @GetMapping("/toMyDocuments")
    public ModelAndView toMyDocuments(HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("myDocuments");
        return modelAndView;
    }
    @GetMapping("/toSearchDocuments")
    public ModelAndView toSearchDocuments(@RequestParam("key")String key, HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("searchDocuments");
        modelAndView.addObject("key",key);
        return modelAndView;
    }
    @GetMapping("/toSearchIndex")
    public ModelAndView toSearchIndex(HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("searchDocumentsIndex");
        return modelAndView;
    }
    @GetMapping("/toAddDocuments")
    public ModelAndView toAddDocuments(HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("addDocuments");
        return modelAndView;
    }
    @GetMapping("/toEditDocuments/{id}")
    public ModelAndView toEditDocuments(@PathVariable(value = "id")Integer id){
        ModelAndView modelAndView=new ModelAndView();
        Document document=documentService.queryByDocumentId(id);
        modelAndView.addObject("document",document);
        modelAndView.setViewName("editDocuments");
        return modelAndView;
    }
    @GetMapping("/toMyGroups")
    public ModelAndView toMyGroups(){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("myGroups");
        return modelAndView;
    }

    /**
     * 通过团队id查看团队文档
     * @param id
     * @return
     */
    @GetMapping("/toGroupDocuments/{id}")
    public ModelAndView toGroupDocuments(@PathVariable(value = "id")Integer id){
        ModelAndView modelAndView=new ModelAndView();
        GroupDto groupDto=groupService.queryGroupInfoByGroupId(id);
        modelAndView.addObject("group",groupDto);
        modelAndView.setViewName("/groupDocuments");
        return modelAndView;
    }
    /**
     * 跳转团队文档编辑界面
     * @param groupId
     * @return
     */
    @GetMapping("/toGroupAddDocuments/{groupId}")
    public ModelAndView toGroupAddDocuments(@PathVariable(value = "groupId")Integer groupId){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.addObject("groupId",groupId);
        modelAndView.setViewName("addGroupDocuments");
        return modelAndView;
    }
    /**
     * 跳转团队文档编辑界面
     * @param id
     * @return
     */
    @GetMapping("/toGroupEdit/{id}")
    public ModelAndView toGroupEdit(@PathVariable(value = "id")Integer id){
        ModelAndView modelAndView=new ModelAndView();
        Document document=documentService.queryByDocumentId(id);
        modelAndView.addObject("document",document);
        modelAndView.setViewName("groupEdit");
        return modelAndView;
    }

    /**
     * 跳转团队成员管理界面
     * @param groupId
     * @return
     */
    @GetMapping("/toGroupMembers/{groupId}")
    public ModelAndView toGroupMembers(@PathVariable(value = "groupId")Integer groupId,HttpSession session){
        User user= (User) session.getAttribute("USER_SESSION");
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.addObject("groupId",groupId);
        GroupMembers condition=new GroupMembers();
        condition.setUserId(user.getId());
        condition.setGroupId(groupId);
        GroupMembers groupMembers=groupService.queryMember(condition);
        modelAndView.addObject("groupMembers",groupMembers);
        modelAndView.setViewName("groupMembers");
        return modelAndView;
    }
    /**
     * 跳转团队成员管理界面
     * @param groupId
     * @return
     */
    @GetMapping("/toGroupConfig/{groupId}")
    public ModelAndView toGroupConfig(@PathVariable(value = "groupId")Integer groupId,HttpSession session){
        User user= (User) session.getAttribute("USER_SESSION");
        ModelAndView modelAndView=new ModelAndView();
        GroupDto groupDto=groupService.queryGroupInfoByGroupId(groupId);
        modelAndView.addObject("group",groupDto);
        GroupMembers condition=new GroupMembers();
        condition.setGroupId(groupId);
        condition.setUserId(user.getId());
        GroupMembers groupMembers=groupService.queryMember(condition);
        modelAndView.addObject("groupMembers",groupMembers);
        modelAndView.setViewName("/groupConfig");
        return modelAndView;
    }
    @GetMapping("/toRecycle")
    public ModelAndView toRestore(HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("recycle");
        return modelAndView;
    }
    @GetMapping("/toInfor")
    public ModelAndView toInfor(HttpSession session){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("infor");
        return modelAndView;
    }
}
