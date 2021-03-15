package com.jit.doc.services;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jit.doc.common.Util;
import com.jit.doc.dao.UserDao;
import com.jit.doc.po.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserService {
    @Autowired
    private UserDao userDao;
    public User queryByEmail(String email){
        return userDao.queryByEmail(email);
    }
    public User queryByNickName(String nickName){
        return userDao.queryByNickName(nickName);
    }
    @Transactional
    public int registerUser(User user){
        user.setHashcode(Util.getVerifyRandom(32));
        return userDao.addUser(user);
    }

    /**
     * 更改用户信息
     * @param user
     * @return
     */
    @Transactional
    public int updateUser(User user){
        return userDao.updateUser(user);
    }
}
