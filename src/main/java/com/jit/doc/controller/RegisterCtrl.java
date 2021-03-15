package com.jit.doc.controller;

import com.jit.doc.common.MailUtils;
import com.jit.doc.common.Result;
import com.jit.doc.common.Util;
import com.jit.doc.po.User;
import com.jit.doc.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/common/register")
public class RegisterCtrl extends BaseCtrl {
    @Autowired
    private MailUtils mailUtils;
    @Autowired
    private UserService userService;
    /**
     * 发送带有激活码邮件
     * @param request
     * @return
     * @throws MessagingException
     */
    @GetMapping("/sendVerificationCode")
    public Result sendVerificationCode(@RequestParam(value = "email",required = true) String email, HttpServletRequest request, HttpSession session) throws MessagingException {
        String code= Util.getRandomNumber(6);
        mailUtils.sendMail(code,email,request);
        session.setAttribute("mailCode",code);
        session.setAttribute("mail",email);
        return this.send(null);
    }
    @GetMapping("/isExistEmail")
    public Result isExistEmail(@RequestParam("email") String email){
        User user=userService.queryByEmail(email);
        if(user!=null)return this.send(false);
        else return this.send(true);
    }
    /**
     * 插入系统用户
     * @param email
     * @param nickName
     * @param password
     * @return
     */
    @PostMapping("/addUser")
    public Result register(@RequestParam(value = "email",required = true) String email,
                           @RequestParam(value = "code",required = true) String code,
                           @RequestParam(value = "nickName",required = true) String nickName,
                           @RequestParam(value = "password",required = true) String password,
                           HttpSession session){
        if(userService.queryByEmail(email)!=null)return this.send(-1,"邮箱已被注册，请重新输入");
        if(userService.queryByNickName(nickName)!=null)return this.send(-1,"用户名存在，请重新输入");
        String _code= (String) session.getAttribute("mailCode");
        String _mail= (String) session.getAttribute("mail");
        if(code==null){
            return this.send(-1,"请填写激活码");
        }
        if(_code==null){
            return this.send(-1,"激活码未发送");
        }
        if(!_mail.equals(email)){
            return this.send(-1,"邮箱改变请重新发送激活码");
        }
        if(!code.equals(_code)){
            return this.send(-1,"激活码错误");
        }
        User user=new User();
        user.setEmail(email);
        user.setNickName(nickName);
        user.setPassword(DigestUtils.md5DigestAsHex(password.getBytes()));
        int result=userService.registerUser(user);
        if(result==0)return this.send(-1,"注册失败");
        else return this.send(null);
    }
}
