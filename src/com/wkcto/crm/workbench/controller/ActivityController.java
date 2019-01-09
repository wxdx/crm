package com.wkcto.crm.workbench.controller;

import com.alibaba.fastjson.JSON;
import com.wkcto.crm.utils.*;
import com.wkcto.crm.workbench.domain.Activity;
import com.wkcto.crm.workbench.domain.ActivityRemark;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.workbench.service.ActivityService;
import com.wkcto.crm.workbench.service.impl.ActivityServiceImpl;
import com.wkcto.crm.vo.PaginationVO;
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
 * 市场活动控制
 */
public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        ActivityService activityService = (ActivityService) new TransactionInvocationHandler(new ActivityServiceImpl()).getProxy();
        if ("/workbench/activity/getOwner.do".equals(path)) {
            getOwner(request, response, activityService);
        } else if ("/workbench/activity/save.do".equals(path)) {
            save(request, response, activityService);
        } else if ("/workbench/activity/page.do".equals(path)) {
            getPage(request, response, activityService);
        } else if ("/workbench/activity/edit.do".equals(path)) {
            getEditInfo(request, response, activityService);
        } else if ("/workbench/activity/update.do".equals(path)) {
            doUpdate(request, response, activityService);
        } else if ("/workbench/activity/delete.do".equals(path)) {
            doDelete(request, response, activityService);
        } else if ("/workbench/activity/detail.do".equals(path)) {
            doDetail(request, response, activityService);
        } else if ("/workbench/activity/getRemarkList.do".equals(path)) {
            getRemarkList(request, response, activityService);
        } else if ("/workbench/activity/remarkSave.do".equals(path)) {
            remarkSave(request, response, activityService);
        } else if ("/workbench/activity/deleteRemark.do".equals(path)) {
            deleteRemark(request, response, activityService);
        } else if ("/workbench/activity/updateRemark.do".equals(path)) {
            updateRemark(request, response, activityService);
        } else if ("/workbench/activity/exportAll.do".equals(path)) {
            doExportAll(request, response, activityService);
        } else if ("/workbench/activity/exportCheckAll.do".equals(path)) {
            doExportCheckAll(request, response, activityService);
        } else if ("/workbench/activity/import.do".equals(path)) {
            doImport(request, response, activityService);
        }
    }

    protected void doImport(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Activity> dataList = new ArrayList<>();
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
                        ReadExcel<Activity> readExcel = new ReadExcel<>();
                        dataList = readExcel.doRead(item.getInputStream(), Activity.class, dataList);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        boolean flag = false;
        Map<String, Boolean> map = new HashMap<>();
        if (dataList.size() != 0) {
            flag = activityService.doImport(dataList);
        }
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doExportCheckAll(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        String[] excelHeader = {"id#id", "所有人#owner", "名称#name", "开始时间#startTime", "结束时间#endTime", "成本#cost", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime", "描述#description"};
        String className = "市场活动表";
        List<Activity> aList = activityService.getAllCheckActivity(id);
        try {
            ExportExcel2010Util.export(response, className, excelHeader, aList);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    protected void doExportAll(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String[] excelHeader = {"Id#id", "所有人#owner", "名称#name", "开始时间#startTime", "结束时间#endTime", "成本#cost", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime", "描述#description"};
        List<Activity> aList = activityService.getAllActivity();
        String className = "市场活动表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, aList);
        } catch (Exception e) {
            e.printStackTrace();
        }
        /*List<Activity> aList = activityService.getAllActivity();
        System.out.println(aList.size());
        HSSFWorkbook workbook = ExcelUtil.export("市场活动表1",Activity.class,aList);
        response.setContentType("application/vnd.ms-excel;charset=utf-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + System.currentTimeMillis() + ".xls");
        workbook.write(response.getOutputStream());*/

    }

    protected void updateRemark(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        ActivityRemark activityRemark = RequestToBeanUtil.autoSet(request, ActivityRemark.class);
        Map<String, Object> map = activityService.updateRemark(activityRemark);
        OutJson.print(request, response, map);
    }

    protected void deleteRemark(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String id = request.getParameter("id");
        System.out.println(id);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", activityService.deleteRemark(id) == 1);
        OutJson.print(request, response, map);
    }

    protected void remarkSave(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        ActivityRemark activityRemark = RequestToBeanUtil.autoSet(request, ActivityRemark.class);
        Map<String, Object> map = activityService.doRemarkSave(activityRemark);
        OutJson.print(request, response, map);
    }

    protected void getRemarkList(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String activityId = request.getParameter("activityId");
        List<ActivityRemark> aList = activityService.getRemarkList(activityId);
        System.out.println(JSON.toJSONString(aList));
        OutJson.print(request, response, aList);
    }

    protected void doDetail(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, String> map = activityService.getEditInfo(id);
        request.setAttribute("map", map);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request, response);
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        int i = activityService.doDelete(id);
        if (i >= 1) {
            response.sendRedirect(request.getContextPath() + "/workbench/activity/index.jsp");
        }
    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        Activity activity = RequestToBeanUtil.autoSet(request, Activity.class);
        int i = activityService.doUpdate(activity);
        if (i == 1) {
            response.sendRedirect(request.getContextPath() + "/workbench/activity/index.jsp");
        }
    }

    protected void getEditInfo(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, String> map = activityService.getEditInfo(id);
        OutJson.print(request, response, map);
    }

    protected void getPage(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        Integer pageSize = Integer.valueOf(request.getParameter("pageSize"));
        Integer pageNo = Integer.valueOf(request.getParameter("pageNo"));
        String name = request.getParameter("name");
        String ownerName = request.getParameter("ownerName");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("ownerName", ownerName);
        map.put("startTime", startTime);
        map.put("endTime", endTime);
        map.put("pageIndex", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        PaginationVO<Activity> page1 = activityService.page(map);
        OutJson.print(request, response, page1);

    }

    protected void save(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        Activity activity = RequestToBeanUtil.autoSet(request, Activity.class);
        activity.setId(UUIDGenerator.generate());
        activity.setCreateTime(DateUtil.getSysTime());
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", activityService.save(activity) == 1);
        OutJson.print(request, response, map);
    }

    protected void getOwner(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        List<User> uList = activityService.getOwner();
        OutJson.print(request, response, uList);
    }
}
