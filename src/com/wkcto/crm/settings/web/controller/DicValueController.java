package com.wkcto.crm.settings.web.controller;


import com.wkcto.crm.settings.service.DicValueService;
import com.wkcto.crm.settings.service.impl.DicValueServiceImpl;
import com.wkcto.crm.settings.domain.DicValue;
import com.wkcto.crm.utils.OutJson;
import com.wkcto.crm.utils.RequestToBeanUtil;
import com.wkcto.crm.utils.TransactionInvocationHandler;
import com.wkcto.crm.utils.UUIDGenerator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class DicValueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        System.out.println(path);
        DicValueService dicValueService = (DicValueService) new TransactionInvocationHandler(new DicValueServiceImpl()).getProxy();
        if ("/settings/dictionary/value/getType.do".equals(path)) {
            getType(request, response, dicValueService);
        } else if ("/settings/dictionary/value/save.do".equals(path)) {
            doSave(request, response, dicValueService);
        } else if ("/settings/dictionary/value/list.do".equals(path)) {
            getList(request, response, dicValueService);
        } else if ("/settings/dictionary/value/getOneValue.do".equals(path)) {
            doGetOne(request, response, dicValueService);
        } else if ("/settings/dictionary/value/update.do".equals(path)) {
            doUpdate(request, response, dicValueService);
        } else if ("/settings/dictionary/value/delete.do".equals(path)) {
            doDelete(request, response, dicValueService);
        } else if ("/settings/dictionary/value/checkValue.do".equals(path)) {
            checkValue(request, response, dicValueService);
        } else if ("/settings/dictionary/value/getTypeName.do".equals(path)) {
            getTypeName(request, response, dicValueService);
        }
    }

    protected void getTypeName(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {
        String typeCode1 = request.getParameter("typeCode1");
        Map<String, String> map = dicValueService.getTypeName(typeCode1);
        OutJson.print(request, response, map);
    }

    protected void checkValue(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {
        String typeCode = request.getParameter("typeCode");
        String value = request.getParameter("value");

        Map<String, Boolean> map = new HashMap<>();
        map.put("result", dicValueService.checkValue(typeCode, value) == 0);
        OutJson.print(request, response, map);
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        if (dicValueService.doDelete(id) >= 1) {
            response.sendRedirect(request.getContextPath() + "/settings/dictionary/value/index.jsp");
        }
    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {

        DicValue dicValue = RequestToBeanUtil.autoSet(request, DicValue.class);

        if (dicValueService.doUpdate(dicValue) == 1) {
            response.sendRedirect(request.getContextPath() + "/settings/dictionary/value/index.jsp");
        }

    }

    protected void doGetOne(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {
        String id = request.getParameter("id");
        DicValue dicValue = dicValueService.getOne(id);
        OutJson.print(request, response, dicValue);
    }

    protected void getList(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {
        List<DicValue> dList = dicValueService.getList();
        OutJson.print(request, response, dList);
    }

    protected void doSave(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {
        DicValue dicValue = RequestToBeanUtil.autoSet(request, DicValue.class);
        if (dicValueService.doSave(dicValue) == 1) {
            response.sendRedirect(request.getContextPath() + "/settings/dictionary/value/index.jsp");
        }

    }

    protected void getType(HttpServletRequest request, HttpServletResponse response, DicValueService dicValueService) throws ServletException, IOException {
        List<Map<String, String>> sList = dicValueService.getType();
        OutJson.print(request, response, sList);
    }

}
