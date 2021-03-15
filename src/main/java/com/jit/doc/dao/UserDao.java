package com.jit.doc.dao;


import com.jit.doc.dto.UserDto;
import com.jit.doc.po.User;

import java.util.List;

public interface UserDao {
    public int addUser(User user);
    public User queryByEmail(String email);
    public User queryByNickName(String nickName);
    public List<UserDto> queryMembers(Integer groupId);
    public int updateUser(User user);
}
