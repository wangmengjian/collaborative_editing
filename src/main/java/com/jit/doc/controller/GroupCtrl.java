package com.jit.doc.controller;

import com.jit.doc.common.Result;
import com.jit.doc.po.Document;
import com.jit.doc.po.Group;
import com.jit.doc.po.GroupMembers;
import com.jit.doc.po.User;
import com.jit.doc.services.DocumentService;
import com.jit.doc.services.GroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/group")
public class GroupCtrl extends BaseCtrl{
    @Autowired
    private GroupService groupService;
    @Autowired
    private DocumentService documentService;

    /**
     * 创建团队
     * @param group
     * @param session
     * @return
     */
    @RequestMapping("/addGroup")
    public Result addGroup(Group group,HttpSession session){
        User user= (User) session.getAttribute("USER_SESSION");
        group.setCreateUserId(user.getId());
        group.setCreateUsername(user.getNickName());
        if(groupService.hasSameNameGroup(user.getId(),group.getGroupName()))return this.send(-1,"已经含有相同名称的团队");
        return this.send(groupService.addGroup(group,user));
    }

    /**
     * 更新团队信息
     * @param group
     * @return
     */
    @RequestMapping("/updateGroup")
    public Result updateGroup(Group group){
        return this.send(groupService.updateGroup(group));
    }
    /**
     * 删除团队
     * @param groupId
     * @return
     */
    @RequestMapping("/deleteGroup")
    public Result updateGroup(Integer groupId){
        return this.send(groupService.deleteGroup(groupId));
    }
    /**
     * 退出团队
     * @param groupMembers
     * @return
     */
    @RequestMapping("/exitGroup")
    public Result exitGroup(GroupMembers groupMembers){
        return this.send(groupService.deleteMember(groupMembers));
    }
    /**
     * 查询我的团队
     * @param status 团队分类:0所有团队，1我创建的，2我加入的
     * @param session
     * @return
     */
    @RequestMapping("/queryGroup")
    public Result queryGroup(@RequestParam(value = "status",required = true) Integer status,
                             @RequestParam(value = "pageNumber",required = true)Integer pageNumber,
                             @RequestParam(value = "pageSize",required = true)Integer pageSize, HttpSession session){
        User user= (User) session.getAttribute("USER_SESSION");
        if(status==0){
            return this.send(groupService.queryAllGroups(pageNumber,pageSize,user.getId()));
        }else if(status==1){
            return this.send(groupService.queryMyCreateGroups(pageNumber,pageSize,user.getId()));
        }else{
            return this.send(groupService.queryMyJoinGroups(pageNumber,pageSize,user.getId()));
        }
    }

    /**
     * 查询团队文档
     * @param groupId
     * @param pageNumber
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryGroupDocuments")
    public Result queryGroupDocuments(@RequestParam(value = "groupId",required = true)Integer groupId,
                                      @RequestParam(value = "pageNumber",required = true)Integer pageNumber,
                                      @RequestParam(value = "pageSize",required = true)Integer pageSize
                                      ){
        return this.send(documentService.queryGroupDocuments(groupId,pageNumber,pageSize));
    }

    /**
     * 添加团队文档
     * @param document
     * @param session
     * @return
     */
    @RequestMapping("/addDocument")
    public Result addDocument(Document document, HttpSession session){
        User user= (User) session.getAttribute("USER_SESSION");
        return this.send(groupService.addDocument(document,user));
    }
    @RequestMapping("/queryMembers")
    public Result queryMembers(@RequestParam(value = "groupId",required = true)Integer groupId,
                               @RequestParam(value = "pageNumber",required = true)Integer pageNumber,
                               @RequestParam(value = "pageSize",required = true)Integer pageSize){
        return this.send(groupService.queryMembers(groupId,pageNumber,pageSize));
    }

    /**
     * 添加普通成员
     * @param members
     * @return
     */
    @RequestMapping("/addMember")
    public Result addMember(GroupMembers members){
        if(groupService.queryMember(members)!=null)return this.send(-1,"已经添加该用户");
        return this.send(groupService.addMember(members));
    }
    @RequestMapping("/updateMember")
    public Result updateMember(GroupMembers groupMembers){
        return this.send(groupService.updateMembers(groupMembers));
    }

    /**
     * 删除团队成员
     * @param groupId
     * @param userIds
     * @return
     */
    @RequestMapping("/deleteMembers")
    public Result deleteMembers(@RequestParam("groupId")Integer groupId,
                                @RequestParam("userIds")Integer[] userIds){
        if(userIds.length==0)return null;
        List<Integer> idList=new ArrayList<>();
        for(int i=0;i<userIds.length;i++){
            idList.add(userIds[i]);
        }
        return this.send(groupService.deleteMembers(groupId,idList));
    }
    @RequestMapping("/doSomeChanges")
    public Result doSomeChanges(String content){
        return null;
    }
}
