package com.jit.doc.controller;

import com.jit.doc.common.Result;
import com.jit.doc.po.User;
import com.jit.doc.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/user")
public class UserCtrl extends BaseCtrl {
    @Autowired
    private UserService userService;
    @RequestMapping("/queryUserByNickName")
    public Result queryUserByNickName(@RequestParam(value = "nickName",required = true)String nickName){
        return this.send(userService.queryByNickName(nickName));
    }

    /**
     * 更新用户的基本信息
     * @param user
     * @param session
     * @return
     */
    @RequestMapping("/updateUserInfor")
    public Result updateUserInfor(User user, HttpSession session){
        User oldUser= (User) session.getAttribute("USER_SESSION");
        if(!oldUser.getNickName().equals(user.getNickName())&&userService.queryByNickName(user.getNickName())!=null)return this.send(-1,"用户名存在，请重新输入");
        user.setId(oldUser.getId());
        user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        session.setAttribute("USER_SESSION",user);
        return this.send(userService.updateUser(user));
    }
}
