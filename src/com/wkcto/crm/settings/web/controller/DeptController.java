package com.wkcto.crm.settings.web.controller;

import com.wkcto.crm.settings.service.DeptService;
import com.wkcto.crm.settings.service.impl.DeptServiceImpl;
import com.wkcto.crm.settings.domain.Dept;
import com.wkcto.crm.utils.OutJson;
import com.wkcto.crm.utils.RequestToBeanUtil;
import com.wkcto.crm.utils.TransactionInvocationHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门控制器
 */
public class DeptController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        DeptService deptService = (DeptService) new TransactionInvocationHandler(new DeptServiceImpl()).getProxy();
        if ("/settings/dept/add.do".equals(path)) {
            doSave(request, response, deptService);
        } else if ("/settings/dept/checkNo.do".equals(path)) {
            doCheck(request, response, deptService);
        } else if ("/settings/dept/getList.do".equals(path)) {
            doGetList(request, response, deptService);
        } else if ("/settings/dept/getOne.do".equals(path)) {
            doGetOne(request, response, deptService);
        } else if ("/settings/dept/update.do".equals(path)) {
            doUpdate(request, response, deptService);
        } else if ("/settings/dept/delete.do".equals(path)) {
            doDelete(request, response, deptService);
        }
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, DeptService deptService) throws ServletException, IOException {
        String[] deptno = request.getParameterValues("deptno");
        if (deptService.doDelete(deptno) >= 1) {
            response.sendRedirect(request.getContextPath() + "/settings/dept/index.jsp");
        }
    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, DeptService deptService) throws ServletException, IOException {
        String deptno = request.getParameter("deptno");
        String oldDeptno = request.getParameter("oldDeptno");
        String name = request.getParameter("name");
        String leader = request.getParameter("leader");
        String phone = request.getParameter("phone");
        String description = request.getParameter("description");


        Map<String, String> map = new HashMap<>();
        map.put("deptno", deptno);
        map.put("oldDeptno", oldDeptno);
        map.put("name", name);
        map.put("leader", leader);
        map.put("phone", phone);
        map.put("description", description);

        Map<String, Boolean> map1 = new HashMap<>();
        map1.put("success", deptService.doUpdate(map) == 1);
        OutJson.print(request, response, map1);

    }

    protected void doGetOne(HttpServletRequest request, HttpServletResponse response, DeptService deptService) throws ServletException, IOException {
        String deptno = request.getParameter("deptno");
        Dept dept = deptService.doGetOne(deptno);
        OutJson.print(request, response, dept);

    }

    protected void doGetList(HttpServletRequest request, HttpServletResponse response, DeptService deptService) throws ServletException, IOException {
        List<Dept> dList = deptService.doGetList();
        OutJson.print(request, response, dList);
    }

    protected void doCheck(HttpServletRequest request, HttpServletResponse response, DeptService deptService) throws ServletException, IOException {
        String deptno = request.getParameter("deptno");
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", deptService.doCheck(deptno) == 0);
        OutJson.print(request, response, map);


    }

    protected void doSave(HttpServletRequest request, HttpServletResponse response, DeptService deptService) throws ServletException, IOException {
        Dept dept = RequestToBeanUtil.autoSet(request, Dept.class);

        Map<String, Boolean> map = new HashMap<>();
        map.put("success", deptService.doSave(dept) == 1);
        OutJson.print(request, response, map);
    }
}
