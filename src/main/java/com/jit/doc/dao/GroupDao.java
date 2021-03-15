package com.jit.doc.dao;


import com.jit.doc.po.Group;
import com.jit.doc.po.GroupMembers;
import com.jit.doc.po.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface GroupDao {
    public int addGroup(Group group);
    public int updateGroup(Group group);
    public List<Group> queryGroups(Map<String,Object> params);
    public int addMember(GroupMembers groupMembers);
    public GroupMembers queryMember(GroupMembers groupMembers);
    //我加入的
    public List<Group> queryJoinGroupsByUserId(Integer userId);
    public List<Group> queryAllGroups(Integer userId);
    public int updateGroupMembers(GroupMembers groupMembers);
    public int deleteMembers(@Param("groupId")Integer groupId,@Param("userIds")List<Integer> userIds);
    public int deleteMember(GroupMembers groupMembers);
}
