package com.wkcto.crm.web.controller;

import com.wkcto.crm.exception.LoginException;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.settings.service.UserService;
import com.wkcto.crm.settings.service.impl.UserServiceImpl;
import com.wkcto.crm.utils.Const;
import com.wkcto.crm.utils.TransactionInvocationHandler;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class WelcomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //获取所有cookie
        Cookie[] cookies = request.getCookies();

        String loginAct = null;
        String loginPwd = null;

        //遍历cookie数组,取出loginAct,loginPwd的value
        if (cookies != null){
            for (Cookie cookie:cookies){
                String name = cookie.getName();
                if ("loginAct".equals(name)){
                    loginAct = cookie.getValue();
                } else if ("loginPwd".equals(name)){
                    loginPwd = cookie.getValue();
                }
            }
        }
        //通过cookie获取到loginAct,loginPwd 进一步验证登录
        if (loginAct != null && loginPwd != null){
            UserService userService = (UserService) new TransactionInvocationHandler(new UserServiceImpl()).getProxy();
            try {
                User user = userService.login(loginAct,loginPwd,request.getRemoteAddr());
                request.getSession().setAttribute(Const.Session_User,user);
                response.sendRedirect(request.getContextPath()+"/workbench/index.jsp");
            } catch (LoginException e) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}
