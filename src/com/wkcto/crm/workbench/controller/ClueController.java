package com.wkcto.crm.workbench.controller;

import com.alibaba.fastjson.JSON;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.utils.*;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.*;
import com.wkcto.crm.workbench.service.ActivityService;
import com.wkcto.crm.workbench.service.ClueActivityRelationService;
import com.wkcto.crm.workbench.service.ClueService;
import com.wkcto.crm.workbench.service.impl.ActivityServiceImpl;
import com.wkcto.crm.workbench.service.impl.ClueActivityRelationServiceImpl;
import com.wkcto.crm.workbench.service.impl.ClueServiceImpl;
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
import java.util.*;

/**
 * 线索控制器
 */
public class ClueController extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        ClueService clueService = (ClueService) new TransactionInvocationHandler(new ClueServiceImpl()).getProxy();
        ClueActivityRelationService clueActivityRelationService = (ClueActivityRelationService) new TransactionInvocationHandler(new ClueActivityRelationServiceImpl()).getProxy();
        ActivityService activityService = (ActivityService) new TransactionInvocationHandler(new ActivityServiceImpl()).getProxy();
        if ("/workbench/clue/getAllUser.do".equals(path)) {
            getAllUser(request, response);
        } else if ("/workbench/clue/save.do".equals(path)) {
            doSave(request, response, clueService);
        } else if ("/workbench/clue/page.do".equals(path)) {
            doPage(request, response, clueService);
        } else if ("/workbench/clue/detail.do".equals(path)) {
            getDetail(request, response, clueService);
        } else if ("/workbench/clue/getOne.do".equals(path)) {
            getOne(request, response, clueService);
        } else if ("/workbench/clue/update.do".equals(path)) {
            doUpdate(request, response, clueService);
        } else if ("/workbench/clue/delete.do".equals(path)) {
            doDelete(request, response, clueService);
        } else if ("/workbench/clue/exportAll.do".equals(path)) {
            doExportAll(request, response, clueService);
        } else if ("/workbench/clue/exportCheckAll.do".equals(path)) {
            doExportCheck(request, response, clueService);
        } else if ("/workbench/clue/import.do".equals(path)) {
            doImport(request, response, clueService);
        } else if ("/workbench/clue/getRemarkList.do".equals(path)) {
            getRemarkList(request, response, clueService);
        } else if ("/workbench/clue/remarkSave.do".equals(path)) {
            doRemarkSave(request, response, clueService);
        } else if ("/workbench/clue/updateRemark.do".equals(path)) {
            doRemarkUpdate(request, response, clueService);
        } else if ("/workbench/clue/deleteRemark.do".equals(path)) {
            doRemarkDelete(request, response, clueService);
        } else if ("/workbench/clue/getActivity.do".equals(path)) {
            doGetActivityByClueId(request, response, clueActivityRelationService);
        } else if ("/workbench/clue/getNeverRelationActivity.do".equals(path)) {
            doGetNeverRelationActivity(request, response, activityService);
        } else if ("/workbench/clue/relationClueAndActivity.do".equals(path)) {
            doRelationClueAndActivity(request, response, clueActivityRelationService);
        } else if ("/workbench/clue/dissociated.do".equals(path)) {
            doDissociatedById(request, response, clueActivityRelationService);
        } else if ("/workbench/clue/convert.do".equals(path)) {
            doConvert(request, response, clueService);
        } else if ("/workbench/clue/getActivity1.do".equals(path)) {
            doGetAllActivity(request, response, activityService);
        } else if ("/workbench/clue/sendEmail.do".equals(path)) {
            sendEmail(request, response);
        }
    }

    protected void sendEmail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String internetAddress = request.getParameter("internetAddress");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        Map<String, Boolean> map = new HashMap<>();
        SendEmail.send(internetAddress, subject, message);
        map.put("success", true);
        OutJson.print(request, response, map);

    }

    protected void doGetAllActivity(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String name = request.getParameter("name");
        List<Activity> list = activityService.getAll(name);
        OutJson.print(request, response, list);
    }

    protected void doConvert(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String clueId = request.getParameter("clueId");
        String flag = request.getParameter("flag");
        Tran tran = null;
        if ("1".equals(flag)) {
            String id = UUIDGenerator.generate();
            // String owner = request.getParameter("");
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            // String customerId = request.getParameter("");
            String stage = request.getParameter("stage");
            //String type = request.getParameter("");
            //String source = request.getParameter("");
            String activityId = request.getParameter("activityId");
            // String contactsId  = request.getParameter("");
            // String description = request.getParameter("");
            // String contactSummary = request.getParameter("");
            // String nextContactTime = request.getParameter("");
            // String createBy = request.getParameter("");
            String createTime = DateUtil.getSysTime();
            tran = new Tran();
            tran.setId(id);
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setActivityId(activityId);
            tran.setCreateTime(createTime);
        }
        try {
            String operator = ((User) request.getSession().getAttribute(Const.Session_User)).getName();
            clueService.convert(clueId, operator, tran);
            OutJson.print(request, response, true);
        } catch (Exception e) {
            OutJson.print(request, response, false);
            e.printStackTrace();
        }

    }

    protected void doDissociatedById(HttpServletRequest request, HttpServletResponse response, ClueActivityRelationService clueActivityRelationService) throws ServletException, IOException {
        String id = request.getParameter("id");
        boolean flag = clueActivityRelationService.doDissociatedById(id);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);

    }

    protected void doRelationClueAndActivity(HttpServletRequest request, HttpServletResponse response, ClueActivityRelationService clueActivityRelationService) throws ServletException, IOException {
        String activityId[] = request.getParameterValues("activityId");
        String clueId = request.getParameter("clueId");
        List<ClueActivityRelation> dataList = new ArrayList<>();
        for (int i = 0; i < activityId.length; i++) {
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDGenerator.generate());
            clueActivityRelation.setActivityId(activityId[i]);
            clueActivityRelation.setClueId(clueId);
            dataList.add(clueActivityRelation);
        }
        boolean flag = clueActivityRelationService.relationClueAndActivity(dataList);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);

    }

    protected void doGetNeverRelationActivity(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String clueId = request.getParameter("clueId");
        String name = request.getParameter("name");
        List<Activity> aList = activityService.doGetNeverRelationActivity(clueId, name);
        OutJson.print(request, response, aList);
    }

    protected void doGetActivityByClueId(HttpServletRequest request, HttpServletResponse response, ClueActivityRelationService clueActivityRelationService) throws ServletException, IOException {
        String clueId = request.getParameter("clueId");
        List<Map<String, Object>> dataList = clueActivityRelationService.getActivityByClueId(clueId);
        System.out.println(JSON.toJSONString(dataList));
        OutJson.print(request, response, dataList);
    }

    protected void doRemarkDelete(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", clueService.deleteRemark(id) == 1);
        OutJson.print(request, response, map);
    }

    protected void doRemarkUpdate(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        ClueRemark clueRemark = RequestToBeanUtil.autoSet(request, ClueRemark.class);
        Map<String, Object> map = clueService.updateRemark(clueRemark);
        OutJson.print(request, response, map);
    }

    protected void doRemarkSave(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        ClueRemark clueRemark = RequestToBeanUtil.autoSet(request, ClueRemark.class);
        clueRemark.setId(UUIDGenerator.generate());
        Map<String, Object> map = clueService.doRemarkSave(clueRemark);
        OutJson.print(request, response, map);
    }

    protected void getRemarkList(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String clueId = request.getParameter("clueId");
        List<ClueRemark> aList = clueService.getRemarkList(clueId);
        System.out.println(JSON.toJSONString(aList));
        OutJson.print(request, response, aList);
    }

    protected void doImport(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Clue> dataList = new ArrayList<>();
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
                        ReadExcel<Clue> readExcel = new ReadExcel<>();
                        dataList = readExcel.doRead(item.getInputStream(), Clue.class, dataList);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        boolean flag = false;
        Map<String, Boolean> map = new HashMap<>();
        if (dataList.size() != 0) {
            flag = clueService.doImport(dataList);
        }
        map.put("success", flag);
        OutJson.print(request, response, map);

    }

    protected void doExportCheck(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        String[] excelHeader = {"id#id", "所有者#owner", "公司#company", "称呼#appellation", "姓名#fullname", "职位#job", "电子邮件#email", "公司电话#phone", "公司网站#website", "手机号#mphone", "线索状态#state", "线索来源#source", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "详细地址#address", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Clue> dataList = clueService.getCheckAllClue(id);
        String className = "线索表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    protected void doExportAll(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String[] excelHeader = {"id#id", "所有者#owner", "公司#company", "称呼#appellation", "姓名#fullname", "职位#job", "电子邮件#email", "公司电话#phone", "公司网站#website", "手机号#mphone", "线索状态#state", "线索来源#source", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "详细地址#address", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Clue> dataList = clueService.getAllClue();
        String className = "线索表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        boolean flag = clueService.doDelete(id);
        if (flag) {
            response.sendRedirect(request.getContextPath() + "/workbench/clue/index.jsp");
        }

    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        Clue clue = RequestToBeanUtil.autoSet(request, Clue.class);
        boolean flag = clueService.doUpdate(clue);
        if (flag) {
            response.sendRedirect(request.getContextPath() + "/workbench/clue/index.jsp");
        }

    }

    protected void getOne(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = clueService.getDetail(id);
        OutJson.print(request, response, map);
    }

    protected void getDetail(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = clueService.getDetail(id);
        request.setAttribute("map", map);
        request.getRequestDispatcher("detail.jsp").forward(request, response);
    }

    protected void doPage(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        Integer pageSize = Integer.valueOf(request.getParameter("pageSize"));
        Integer pageNo = Integer.valueOf(request.getParameter("pageNo"));
        String fullname = request.getParameter("fullname");
        String company = request.getParameter("company");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");
        String owner = request.getParameter("owner");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");


        Map<String, Object> map = new HashMap<>();
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("pageIndex", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        PaginationVO<Clue> page = clueService.page(map);
        OutJson.print(request, response, page);
    }

    protected void doSave(HttpServletRequest request, HttpServletResponse response, ClueService clueService) throws ServletException, IOException {
        Clue clue = RequestToBeanUtil.autoSet(request, Clue.class);
        clue.setId(UUIDGenerator.generate());
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", clueService.doSave(clue));
        OutJson.print(request, response, map);
    }

    protected void getAllUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ActivityService activityService = (ActivityService) new TransactionInvocationHandler(new ActivityServiceImpl()).getProxy();
        List<User> uList = activityService.getOwner();
        System.out.println(JSON.toJSONString(uList));
        OutJson.print(request, response, uList);
    }
}
