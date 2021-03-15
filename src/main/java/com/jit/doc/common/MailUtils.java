package com.jit.doc.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

/**
 * @author 王梦健
 * @date 2019/7/30 14:06
 */
@Component
public class MailUtils {
    @Autowired
    private JavaMailSender javaMailSender;
    @Autowired
    private SimpleMailMessage message;
    public void sendMail(String code, String toEmail, HttpServletRequest request) throws MessagingException {   //发送普通文本邮件
        message.setTo(toEmail);
        message.setSubject("激活邮件");
        message.setText("欢迎注册云文档，验证码为"+code);
        javaMailSender.send(message);
    }
}
