package com.jit.doc.filter;

import com.jit.doc.po.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebFilter(filterName="authFilter", urlPatterns={"/*"})
@Component
public class AuthFilter implements Filter {

    @Value("${auth.openUrl}")
    private String openUrl;

    @Override
    public void init(FilterConfig args) throws ServletException {}
    private void sentMsg(ServletResponse res, String code, String msg) throws IOException{
        res.setContentType("application/json");
        PrintWriter writer = res.getWriter();
        writer.write("{\n" +
                "    \"status\": {\n" +
                "        \"code\": "+code+",\n" +
                "        \"message\": \""+msg+"\"\n" +
                "    },\n" +
                "    \"result\": null\n" +
                "}");
        writer.close();
    }
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest)request;
        HttpServletResponse res = (HttpServletResponse)response;
        HttpSession session = req.getSession();
        String url = req.getRequestURI();
        User user = (User) session.getAttribute("USER_SESSION");// 登录人
        /*测试人员*/
        /*UserDto user1=new UserDto();
        user1.setId(2);
        user1.setRoleId(1);
        session.setAttribute("USER_SESSION",user1);*/
        if (url.endsWith("login.jsp")
                || url.endsWith("register.jsp")
                || url.indexOf("/dist") != -1
                || url.indexOf("/plugins") != -1
                || url.indexOf("/bower_components/") != -1
                || url.indexOf("/js/") != -1
                || url.indexOf("/css/") != -1
                || url.indexOf("/fonts/") != -1
                || url.indexOf("/img/") != -1
                || url.indexOf("/user/") != -1
                || url.indexOf("/common/") != -1
                || url.indexOf("active") != -1) {
            chain.doFilter(request, response);
        } else {
            if (user == null) {
                res.sendRedirect(req.getContextPath()+"/render/common/toLogin");
            }else{
                chain.doFilter(request, response);
            }
        }
    }

    @Override
    public void destroy() {

    }

    public String[] getOpenUrl() {
        if(this.openUrl == null || this.openUrl.isEmpty()) {
            return null;
        }else{
            return this.openUrl.split(";");
        }
    }
}

