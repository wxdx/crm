package com.wkcto.crm.web.controller;

import com.wkcto.crm.exception.LoginException;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.settings.service.UserService;
import com.wkcto.crm.settings.service.impl.UserServiceImpl;
import com.wkcto.crm.utils.Const;
import com.wkcto.crm.utils.MD5;
import com.wkcto.crm.utils.OutJson;
import com.wkcto.crm.utils.TransactionInvocationHandler;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;

public class LoginController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String loginAct = request.getParameter("loginAct");
        String loginPwd = MD5.get(request.getParameter("loginPwd"));
        String clientIp = InetAddress.getLocalHost().getHostAddress();
        String tenDayAutoLoginFlag = request.getParameter("tenDayAutoLoginFlag");
        UserService userService = (UserService) new TransactionInvocationHandler(new UserServiceImpl()).getProxy();
        Map<String,Object> jsonMap = new HashMap<>();
        try {
            User user = userService.login(loginAct,loginPwd,clientIp);
            request.getSession().setAttribute(Const.Session_User,user);
            if ("ok".equals(tenDayAutoLoginFlag)){
                //创建cookie对象
                Cookie cookie1 = new Cookie("loginAct",loginAct);
                Cookie cookie2 = new Cookie("loginPwd",loginPwd);
                //设置有效时间
                cookie1.setMaxAge(60*60*24*10);
                cookie2.setMaxAge(60*60*24*10);
                //设置关联路径
                cookie1.setPath(request.getContextPath());
                cookie2.setPath(request.getContextPath());
                //发送cookie到浏览器
                response.addCookie(cookie1);
                response.addCookie(cookie2);
            }
            jsonMap.put("success",true);
        } catch (LoginException e) {
            jsonMap.put("success",false);
            jsonMap.put("errorMsg",e.getMessage());
        }
        OutJson.print(request,response,jsonMap);
    }
}
