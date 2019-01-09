package com.wkcto.crm.settings.web.controller;

import com.wkcto.crm.settings.domain.Dept;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.settings.service.DeptService;
import com.wkcto.crm.settings.service.UserService;
import com.wkcto.crm.settings.service.impl.DeptServiceImpl;
import com.wkcto.crm.settings.service.impl.UserServiceImpl;
import com.wkcto.crm.utils.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        UserService userService = (UserService) new TransactionInvocationHandler(new UserServiceImpl()).getProxy();
        if ("/settings/qx/user/getDeptList.do".equals(path)) {
            getDeptList(request, response);
        } else if ("/settings/qx/user/checkLoginAct.do".equals(path)) {
            checkLoginAct(request, response, userService);
        } else if ("/settings/qx/user/save.do".equals(path)) {
            save(request, response, userService);
        }
    }

    protected void save(HttpServletRequest request, HttpServletResponse response, UserService userService) throws ServletException, IOException {
        //自动将请求的参数赋值给javaBean对象,返回该对象
        User user = RequestToBeanUtil.autoSet(request, User.class);

        Map<String, Boolean> map = new HashMap<>();
        map.put("success", userService.save(user) == 1);
        OutJson.print(request, response, map);
    }

    protected void checkLoginAct(HttpServletRequest request, HttpServletResponse response, UserService userService) throws ServletException, IOException {
        String loginAct = request.getParameter("loginAct");
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", userService.checkLoginAct(loginAct) == 0);
        OutJson.print(request, response, map);
    }

    protected void getDeptList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DeptService deptService = (DeptService) new TransactionInvocationHandler(new DeptServiceImpl()).getProxy();
        List<Dept> dList = deptService.getListForUser();
        OutJson.print(request, response, dList);
    }
}
