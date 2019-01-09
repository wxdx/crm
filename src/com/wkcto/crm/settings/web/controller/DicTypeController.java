package com.wkcto.crm.settings.web.controller;

import com.wkcto.crm.settings.service.DicTypeService;
import com.wkcto.crm.settings.service.impl.DicTypeServiceImpl;
import com.wkcto.crm.settings.domain.DicType;
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

public class DicTypeController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        System.out.println(path);
        DicTypeService dicTypeService = (DicTypeService) new TransactionInvocationHandler(new DicTypeServiceImpl()).getProxy();
        if ("/settings/dictionary/type/checkCode.do".equals(path)) {
            doCheckType(request, response, dicTypeService);
        } else if ("/settings/dictionary/type/save.do".equals(path)) {
            doTypeSave(request, response, dicTypeService);
        } else if ("/settings/dictionary/type/list.do".equals(path)) {
            doGetTypeList(request, response, dicTypeService);
        } else if ("/settings/dictionary/type/getOneType.do".equals(path)) {
            doGetOne(request, response, dicTypeService);
        } else if ("/settings/dictionary/type/update.do".equals(path)) {
            doUpdate(request, response, dicTypeService);
        } else if ("/settings/dictionary/type/delete.do".equals(path)) {
            doDelete(request, response, dicTypeService);
        }
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, DicTypeService dicTypeService) throws ServletException, IOException {
        String[] code = request.getParameterValues("code");
        if (dicTypeService.doDelete(code) >= 1) {
            response.sendRedirect(request.getContextPath() + "/settings/dictionary/type/index.jsp");
        }

    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, DicTypeService dicTypeService) throws ServletException, IOException {
        String code = request.getParameter("code");
        String oldCode = request.getParameter("oldCode");
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Map<String, String> map = new HashMap<>();
        map.put("code", code);
        map.put("oldCode", oldCode);
        map.put("name", name);
        map.put("description", description);

        if (dicTypeService.doUpdate(map) == 1) {
            response.sendRedirect(request.getContextPath() + "/settings/dictionary/type/index.jsp");
        }
    }

    protected void doGetOne(HttpServletRequest request, HttpServletResponse response, DicTypeService dicTypeService) throws ServletException, IOException {
        response.setContentType("text/json;charset=utf-8");
        String code = request.getParameter("code");
        DicType dicType = dicTypeService.doGetOne(code);
        OutJson.print(request, response, dicType);
    }

    protected void doGetTypeList(HttpServletRequest request, HttpServletResponse response, DicTypeService dicTypeService) throws ServletException, IOException {
        List<DicType> dList = dicTypeService.doGetTypeList();
        OutJson.print(request, response, dList);
    }

    protected void doCheckType(HttpServletRequest request, HttpServletResponse response, DicTypeService dicTypeService) throws ServletException, IOException {
        String code = request.getParameter("code");
        response.setContentType("text/json;charset=utf-8");
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", dicTypeService.doCheckCode(code) == 0);
        OutJson.print(request, response, map);
    }

    protected void doTypeSave(HttpServletRequest request, HttpServletResponse response, DicTypeService dicTypeService) throws ServletException, IOException {
        DicType dicType = RequestToBeanUtil.autoSet(request, DicType.class);
        if (dicTypeService.doSave(dicType) == 1) {
            response.sendRedirect(request.getContextPath() + "/settings/dictionary/type/index.jsp");
        }
    }
}
