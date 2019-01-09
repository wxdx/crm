package com.wkcto.crm.workbench.controller;

import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.utils.*;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.*;
import com.wkcto.crm.workbench.service.CustomerService;
import com.wkcto.crm.workbench.service.TranService;
import com.wkcto.crm.workbench.service.impl.CustomerServiceImpl;
import com.wkcto.crm.workbench.service.impl.TranServiceImpl;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 交易控制器
 */
public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        String path = request.getServletPath();
        CustomerService customerService = (CustomerService) new TransactionInvocationHandler(new CustomerServiceImpl()).getProxy();
        TranService tranService = (TranService) new TransactionInvocationHandler(new TranServiceImpl()).getProxy();

        if ("/workbench/tran/autoCompleteCustomer.do".equals(path)) {
            doAutoComplete(request, response, customerService);
        } else if ("/workbench/tran/save.do".equals(path)) {
            doSave(request, response, tranService);
        } else if ("/workbench/tran/getTranByCustomerId.do".equals(path)) {
            doGetTranByCustomerId(request, response, tranService);
        } else if ("/workbench/tran/delTran.do".equals(path)) {
            doDelById(request, response, tranService);
        } else if ("/workbench/tran/getTranByContactsId.do".equals(path)) {
            doGetTranByContactsId(request, response, tranService);
        } else if ("/workbench/tran/page.do".equals(path)) {
            doPage(request, response, tranService);
        } else if ("/workbench/tran/edit.do".equals(path)) {
            doEdit(request, response, tranService);
        } else if ("/workbench/tran/update.do".equals(path)) {
            doUpdate(request, response, tranService);
        } else if ("/workbench/tran/delete.do".equals(path)) {
            doDelete(request, response, tranService);
        } else if ("/workbench/tran/exportAll.do".equals(path)) {
            doExportAll(request, response, tranService);
        } else if ("/workbench/tran/exportCheckAll.do".equals(path)) {
            doExportCheckAll(request, response, tranService);
        } else if ("/workbench/tran/import.do".equals(path)) {
            doImport(request, response, tranService);
        } else if ("/workbench/tran/detail.do".equals(path)) {
            doDetail(request, response, tranService);
        } else if ("/workbench/tran/getHistoryList.do".equals(path)) {
            doGetHistoryList(request, response, tranService);
        } else if ("/workbench/tran/changeStage.do".equals(path)) {
            changeStage(request, response, tranService);
        } else if ("/workbench/tran/getRemarkList.do".equals(path)) {
            doGetRemarkList(request, response, tranService);
        } else if ("/workbench/tran/remarkSave.do".equals(path)) {
            doSaveRemark(request, response, tranService);
        } else if ("/workbench/tran/updateRemark.do".equals(path)) {
            doUpdateRemark(request, response, tranService);
        } else if ("/workbench/tran/deleteRemark.do".equals(path)) {
            doDeleteRemark(request, response, tranService);
        }
    }

    protected void doDeleteRemark(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Boolean> map = new HashMap<>();
        boolean flag = tranService.deleteRemark(id);
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doUpdateRemark(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        TranRemark tranRemark = RequestToBeanUtil.autoSet(request, TranRemark.class);
        tranRemark.setEditTime(DateUtil.getSysTime());
        Map<String, Object> map = tranService.updateRemark(tranRemark);
        OutJson.print(request, response, map);
    }

    protected void doSaveRemark(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        TranRemark tranRemark = RequestToBeanUtil.autoSet(request, TranRemark.class);
        tranRemark.setId(UUIDGenerator.generate());
        tranRemark.setCreateTime(DateUtil.getSysTime());
        Map<String, Object> map = tranService.saveRemark(tranRemark);
        OutJson.print(request, response, map);
    }

    protected void doGetRemarkList(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String tranId = request.getParameter("tranId");
        List<TranRemark> dataList = tranService.getRemarkList(tranId);
        OutJson.print(request, response, dataList);
    }

    protected void changeStage(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        Tran tran = RequestToBeanUtil.autoSet(request, Tran.class);
        tran.setEditBy(((User) request.getSession().getAttribute(Const.Session_User)).getName());
        tran.setEditTime(DateUtil.getSysTime());
        boolean flag = tranService.updateStage(tran);
        Map<String, Object> map = new HashMap<>();
        if (flag) {
            map.put("success", true);
            map.put("stage", tran.getStage());
            map.put("money", tran.getMoney());
            map.put("expectedDate", tran.getExpectedDate());
            map.put("editBy", tran.getEditBy());
            map.put("editTime", tran.getEditTime());
        } else {
            map.put("success", false);
        }
        OutJson.print(request, response, map);
    }

    protected void doGetHistoryList(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String tranId = request.getParameter("tranId");
        List<TranHistory> dataList = tranService.getHistoryList(tranId);
        OutJson.print(request, response, dataList);
    }

    protected void doDetail(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = tranService.getOneById(id);
        request.setAttribute("map", map);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request, response);
    }

    protected void doImport(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Tran> dataList = new ArrayList<>();
        FileItemFactory factory = new DiskFileItemFactory();
        try {
            ((DiskFileItemFactory) factory).setSizeThreshold(1024 * 1024);//设置缓冲大小
            String temPath = this.getServletContext().getRealPath("temp");
            ((DiskFileItemFactory) factory).setRepository(new File(temPath));//设置缓冲路径
            // 文件上传核心工具类
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(10 * 1024 * 1024); // 单个文件大小限制
            upload.setSizeMax(50 * 1024 * 1024); // 总文件大小限制
            upload.setHeaderEncoding("UTF-8"); // 对中文文件编码处理
            if (ServletFileUpload.isMultipartContent(request)) {
                List<FileItem> list = upload.parseRequest(request);
                // 遍历
                for (FileItem item : list) {
                    if (!item.isFormField()) {
                        String filePath = this.getServletContext().getRealPath("files") + "//" + item.getName();
                        item.write(new File(filePath));
                        ReadExcel<Tran> readExcel = new ReadExcel<>();
                        dataList = readExcel.doRead(item.getInputStream(), Tran.class, dataList);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        boolean flag = false;
        Map<String, Boolean> map = new HashMap<>();
        if (dataList.size() != 0) {
            flag = tranService.doImport(dataList);
        }
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doExportCheckAll(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        String[] excelHeader = {"id#id", "所有者#owner", "金额#money", "名称#name", "预计成交日期#expectedDate", "客户Id#customerId", "阶段#stage", "类型#type", "来源#source", "市场源Id#activityId", "联系人Id#contactsId", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Tran> dataList = tranService.getCheckAllTran(id);
        String className = "交易表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doExportAll(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String[] excelHeader = {"id#id", "所有者#owner", "金额#money", "名称#name", "预计成交日期#expectedDate", "客户Id#customerId", "阶段#stage", "类型#type", "来源#source", "市场源Id#activityId", "联系人Id#contactsId", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Tran> dataList = tranService.getAllTran();
        String className = "交易表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        boolean flag = tranService.doDelete(id);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        Tran tran = RequestToBeanUtil.autoSet(request, Tran.class);
        tran.setEditTime(DateUtil.getSysTime());
        boolean flag = tranService.doUpdate(tran);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doEdit(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = tranService.getOneById(id);
        request.setAttribute("map", map);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request, response);
    }

    protected void doPage(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        Integer pageSize = Integer.valueOf(request.getParameter("pageSize"));
        Integer pageNo = Integer.valueOf(request.getParameter("pageNo"));
        String name = request.getParameter("name");
        String stage = request.getParameter("stage");
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String customerName = request.getParameter("customerName");
        String type = request.getParameter("type");
        String contactName = request.getParameter("contactName");

        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("stage", stage);
        map.put("owner", owner);
        map.put("source", source);
        map.put("customerName", customerName);
        map.put("type", type);
        map.put("contactName", contactName);
        map.put("pageIndex", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        PaginationVO<Map<String, Object>> page = tranService.page(map);
        OutJson.print(request, response, page);
    }

    protected void doDelById(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String id = request.getParameter("id");
        boolean flag = tranService.delById(id);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doGetTranByContactsId(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String contactsId = request.getParameter("contactId");
        List<Map<String, Object>> dataList = tranService.getByContactsId(contactsId);
        OutJson.print(request, response, dataList);
    }

    protected void doGetTranByCustomerId(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");
        List<Map<String, Object>> dataList = tranService.getByCustomerId(customerId);
        OutJson.print(request, response, dataList);
    }

    protected void doSave(HttpServletRequest request, HttpServletResponse response, TranService tranService) throws ServletException, IOException {
        Tran tran = RequestToBeanUtil.autoSet(request, Tran.class);
        tran.setId(UUIDGenerator.generate());
        tran.setCreateTime(DateUtil.getSysTime());
        boolean flag = tranService.doSave(tran);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doAutoComplete(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String name = request.getParameter("name");
        List<String> dataList = customerService.getMatchNameByName(name);
        OutJson.print(request, response, dataList);
    }

}
