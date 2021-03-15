package com.jit.doc.controller;

import com.jit.doc.common.Result;
import com.jit.doc.po.User;
import com.jit.doc.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@RestController
@RequestMapping("/api/common/login")
public class LoginCtrl extends BaseCtrl{
    @Autowired
    private UserService userService;
    @RequestMapping("/login")
    public Result login(@RequestParam("email") String email, @RequestParam("password") String password, HttpSession session){
        User _user=userService.queryByEmail(email);
        if(_user==null)return this.send(-1,"邮箱未注册");
        if(!DigestUtils.md5DigestAsHex(password.getBytes()).equals(_user.getPassword())){
            return this.send(-1,"密码输入错误");
        }
        session.setAttribute("USER_SESSION",_user);
        return this.send(null);
    }
    @GetMapping("/outLogin")
    public Result outLogin(HttpSession session, HttpServletResponse res,HttpServletRequest req){
        session.removeAttribute("USER_SESSION");
        try {
            res.sendRedirect(req.getContextPath()+"/render/common/toLogin");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return this.send(null);
    }
}
