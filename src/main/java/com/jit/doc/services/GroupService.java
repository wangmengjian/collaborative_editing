package com.jit.doc.services;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jit.doc.common.FileUtils;
import com.jit.doc.common.Util;
import com.jit.doc.dao.DocumentDao;
import com.jit.doc.dao.GroupDao;
import com.jit.doc.dao.UserDao;
import com.jit.doc.dto.GroupDto;
import com.jit.doc.dto.UserDto;
import com.jit.doc.mapreduce.InvertedIndex;
import com.jit.doc.po.Document;
import com.jit.doc.po.Group;
import com.jit.doc.po.GroupMembers;
import com.jit.doc.po.User;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.beans.Beans;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GroupService {
    @Autowired
    private GroupDao groupDao;
    @Autowired
    private DocumentDao documentDao;
    @Autowired
    private UserDao userDao;
    private SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
    @Autowired
    private HttpSession session;
    /**
     * 添加团队
     * @param group 团队信息
     * @Param user 创建人
     * @return
     */
    @Transactional
    public int addGroup(Group group,User user){
        group.setCreateTime(simpleDateFormat.format(new Date()));
        group.setIsDelete("0");
        groupDao.addGroup(group);
        //添加管理员
        GroupMembers groupMembers=new GroupMembers();
        groupMembers.setGroupId(group.getId());
        groupMembers.setJoinTime(simpleDateFormat.format(new Date()));
        groupMembers.setRoleId("2");
        groupMembers.setUserId(user.getId());
        groupDao.addMember(groupMembers);
        return 1;
    }

    /**
     * 更改团队信息
     * @param group
     * @return
     */
    @Transactional
    public int updateGroup(Group group){
        return groupDao.updateGroup(group);
    }
    /**
     * 删除团队
     * @param groupId
     * @return
     */
    @Transactional
    public int deleteGroup(Integer groupId){
        Group group=new Group();
        group.setId(groupId);
        group.setIsDelete("1");
        return groupDao.updateGroup(group);
    }
    /**
     * 查重
     * @param userId
     * @param groupName
     * @return
     */
    public boolean hasSameNameGroup(Integer userId,String groupName){
        Map<String,Object> params=new HashMap<>();
        params.put("createUserId",userId);
        params.put("groupName",groupName);
        params.put("isDelete","0");
        List<Group> result=groupDao.queryGroups(params);
        if(result==null||result.size()==0)return false;
        return true;
    }

    /**
     * 查询我创建的团队
     * @param pageNumber
     * @param pageSize
     * @param userId
     * @return
     */
    public Map<String,Object> queryMyCreateGroups(Integer pageNumber,Integer pageSize,Integer userId){
        Map<String,Object> params=new HashMap<>();
        params.put("createUserId",userId);
        params.put("isDelete","0");
        PageHelper.startPage(pageNumber,pageSize);
        List<Group> groupList=groupDao.queryGroups(params);
        PageInfo pageInfo=new PageInfo(groupList);
        Map<String,Object> map=new HashMap<>();
        map.put("total",pageInfo.getTotal());
        map.put("size",pageInfo.getSize());
        map.put("data",groupList);
        return map;
    }
    /**
     * 查询我加入的团队
     * @param pageNumber
     * @param pageSize
     * @param userId
     * @return
     */
    public Map<String,Object> queryMyJoinGroups(Integer pageNumber,Integer pageSize,Integer userId){
        Map<String,Object> params=new HashMap<>();
        PageHelper.startPage(pageNumber,pageSize);
        List<Group> groupList=groupDao.queryJoinGroupsByUserId(userId);
        PageInfo pageInfo=new PageInfo(groupList);
        Map<String,Object> map=new HashMap<>();
        map.put("total",pageInfo.getTotal());
        map.put("size",pageInfo.getSize());
        map.put("data",groupList);
        return map;
    }

    /**
     * 查询所有团队
     * @param pageNumber
     * @param pageSize
     * @param userId
     * @return
     */
    public Map<String,Object> queryAllGroups(Integer pageNumber,Integer pageSize,Integer userId){
        Map<String,Object> params=new HashMap<>();
        PageHelper.startPage(pageNumber,pageSize);
        List<Group> groupList=groupDao.queryAllGroups(userId);
        PageInfo pageInfo=new PageInfo(groupList);
        Map<String,Object> map=new HashMap<>();
        map.put("total",pageInfo.getTotal());
        map.put("size",pageInfo.getSize());
        map.put("data",groupList);
        return map;
    }

    /**
     * 通过id查询团队文档
     * @param groupId
     * @return
     */
    public GroupDto queryGroupInfoByGroupId(Integer groupId){
        Map<String,Object> params=new HashMap<>();
        params.put("id",groupId);
        List<Group> groupList=groupDao.queryGroups(params);
        if(groupList==null||groupList.size()==0)return null;
        Group group=groupList.get(0);
        List<Document> documentList=documentDao.queryDocumentsByGroupId(groupId);
        GroupDto groupDto=new GroupDto();
        BeanUtils.copyProperties(group,groupDto);
        groupDto.setDocumentList(documentList);
        List<UserDto> userDtoList=userDao.queryMembers(groupId);
        groupDto.setUserDtoList(userDtoList);
        return groupDto;
    }
    /**
     * 添加团队文档
     */
    @Transactional
    public int addDocument(Document document, User user){
        document.setCreateUserId(user.getId());
        document.setCreateUsername(user.getNickName());
        String now=simpleDateFormat.format(new Date());
        document.setCreateTime(now);
        document.setIsDelete("0");
        document.setUpdateTime(now);
        document.setRecentUpdateUserId(user.getId());
        document.setRecentUpdateUsername(user.getNickName());
        documentDao.addDocument(document);
        String path="/file/"+document.getGroupId()+"/"+ document.getId();
        document.setDocLocation(path);
        FileUtils.upload(FileUtils.getContent(document.getDocContent()),path);
        document.setDocSize(FileUtils.getFileLength(path));
        documentDao.editDocument(document);
        return document.getId();
    }

    /**
     * 分页查询团队成员
     * @param groupId
     * @param pageNumber
     * @param pageSize
     * @return
     */
    public Map<String,Object> queryMembers(Integer groupId,Integer pageNumber,Integer pageSize){
        PageHelper.startPage(pageNumber,pageSize);
        List<UserDto> userDtoList=userDao.queryMembers(groupId);
        PageInfo pageInfo=new PageInfo(userDtoList);
        Map<String,Object> map=new HashMap<>();
        map.put("total",pageInfo.getTotal());
        map.put("size",pageInfo.getSize());
        map.put("data",userDtoList);
        return map;
    }

    /**
     * 查重
     * @param groupMembers
     * @return
     */
    public GroupMembers queryMember(GroupMembers groupMembers){
        return groupDao.queryMember(groupMembers);
    }
    /**
     * 添加普通成员
     * @param groupMembers
     * @return
     */
    @Transactional
    public int addMember(GroupMembers groupMembers){
        groupMembers.setJoinTime(simpleDateFormat.format(new Date()));
        groupMembers.setRoleId("1");
        return groupDao.addMember(groupMembers);
    }

    /**
     * 更改用户在团队中的角色
     * @param groupMembers
     * @return
     */
    @Transactional
    public int updateMembers(GroupMembers groupMembers){
        return groupDao.updateGroupMembers(groupMembers);
    }

    /**
     * 删除团队成员
     * @param groupId
     * @param userIds
     * @return
     */
    @Transactional
    public int deleteMembers(Integer groupId,List<Integer> userIds){
        return groupDao.deleteMembers(groupId,userIds);
    }

    /**
     * 退出团队
     * @param groupMembers
     * @return
     */
    @Transactional
    public int deleteMember(GroupMembers groupMembers){
        return groupDao.deleteMember(groupMembers);
    }
}
