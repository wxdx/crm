package com.wkcto.crm.workbench.controller;


import com.wkcto.crm.utils.*;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.*;
import com.wkcto.crm.workbench.service.ActivityService;
import com.wkcto.crm.workbench.service.ContactActivityRelationService;
import com.wkcto.crm.workbench.service.ContactService;
import com.wkcto.crm.workbench.service.impl.ActivityServiceImpl;
import com.wkcto.crm.workbench.service.impl.ContactActivityRelationServiceImpl;
import com.wkcto.crm.workbench.service.impl.ContactServiceImpl;
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
 * 联系人控制器
 */
public class ContactController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        String path = request.getServletPath();
        ContactService contactService = (ContactService) new TransactionInvocationHandler(new ContactServiceImpl()).getProxy();
        ContactActivityRelationService contactActivityRelationService = (ContactActivityRelationService) new TransactionInvocationHandler(new ContactActivityRelationServiceImpl()).getProxy();
        ActivityService activityService = (ActivityService) new TransactionInvocationHandler(new ActivityServiceImpl()).getProxy();

        if ("/workbench/contact/save.do".equals(path)) {
            doSave(request, response, contactService);
        } else if ("/workbench/contact/getContact.do".equals(path)) {
            getByName(request, response, contactService);
        } else if ("/workbench/contact/page.do".equals(path)) {
            doPage(request, response, contactService);
        } else if ("/workbench/contact/getOne.do".equals(path)) {
            doGetOne(request, response, contactService);
        } else if ("/workbench/contact/update.do".equals(path)) {
            doUpdate(request, response, contactService);
        } else if ("/workbench/contact/delete.do".equals(path)) {
            doDelete(request, response, contactService);
        } else if ("/workbench/contact/exportAll.do".equals(path)) {
            doExportAll(request, response, contactService);
        } else if ("/workbench/contact/exportCheckAll.do".equals(path)) {
            doExportCheckAll(request, response, contactService);
        } else if ("/workbench/contact/import.do".equals(path)) {
            doImport(request, response, contactService);
        } else if ("/workbench/contact/detail.do".equals(path)) {
            getDetail(request, response, contactService);
        } else if ("/workbench/contact/remarkSave.do".equals(path)) {
            doRemarkSave(request, response, contactService);
        } else if ("/workbench/contact/getRemarkList.do".equals(path)) {
            getRemarkListByContactId(request, response, contactService);
        } else if ("/workbench/contact/updateRemark.do".equals(path)) {
            updateRemark(request, response, contactService);
        } else if ("/workbench/contact/deleteRemark.do".equals(path)) {
            deleteRemark(request, response, contactService);
        } else if ("/workbench/contact/getActivity.do".equals(path)) {
            getActivityByContactId(request, response, contactActivityRelationService);
        } else if ("/workbench/contact/dissociated.do".equals(path)) {
            dissociated(request, response, contactActivityRelationService);
        } else if ("/workbench/contact/getNeverRelationActivity.do".equals(path)) {
            doGetNeverRelationActivity(request, response, activityService);
        } else if ("/workbench/contact/relationClueAndActivity.do".equals(path)) {
            doRelationContactAndActivity(request, response, contactActivityRelationService);
        } else if ("/workbench/contact/alertMsg.do".equals(path)) {
            doAlertMsg(request, response, contactService);
        }
    }

    protected void doAlertMsg(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        List<Map<String, Object>> dataList = contactService.getAlertMsg();
        OutJson.print(request, response, dataList);
    }

    protected void doRelationContactAndActivity(HttpServletRequest request, HttpServletResponse response, ContactActivityRelationService contactActivityRelationService) throws ServletException, IOException {
        String activityId[] = request.getParameterValues("activityId");
        String contactId = request.getParameter("contactId");
        List<ContactActivityRelation> dataList = new ArrayList<>();
        for (int i = 0; i < activityId.length; i++) {
            ContactActivityRelation contactActivityRelation = new ContactActivityRelation();
            contactActivityRelation.setId(UUIDGenerator.generate());
            contactActivityRelation.setActivityId(activityId[i]);
            contactActivityRelation.setContactId(contactId);
            dataList.add(contactActivityRelation);
        }
        boolean flag = contactActivityRelationService.relationContactAndActivity(dataList);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doGetNeverRelationActivity(HttpServletRequest request, HttpServletResponse response, ActivityService activityService) throws ServletException, IOException {
        String contactId = request.getParameter("contactId");
        String name = request.getParameter("name");
        List<Activity> aList = activityService.doGetNeverRelationActivity1(contactId, name);
        OutJson.print(request, response, aList);
    }

    protected void dissociated(HttpServletRequest request, HttpServletResponse response, ContactActivityRelationService contactActivityRelationService) throws ServletException, IOException {
        String id = request.getParameter("id");
        boolean flag = contactActivityRelationService.doDissociatedById(id);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void getActivityByContactId(HttpServletRequest request, HttpServletResponse response, ContactActivityRelationService contactActivityRelationService) throws ServletException, IOException {
        String contactId = request.getParameter("contactId");
        List<Map<String, Object>> dataList = contactActivityRelationService.getActivityByContactId(contactId);
        OutJson.print(request, response, dataList);
    }

    protected void deleteRemark(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Boolean> map = new HashMap<>();
        boolean flag = contactService.deleteRemark(id);
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void updateRemark(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        ContactRemark contactRemark = RequestToBeanUtil.autoSet(request, ContactRemark.class);
        contactRemark.setEditTime(DateUtil.getSysTime());
        Map<String, Object> map = contactService.updateRemark(contactRemark);
        OutJson.print(request, response, map);
    }

    protected void getRemarkListByContactId(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String contactId = request.getParameter("contactId");
        List<ContactRemark> dataList = contactService.getRemarkListByContactId(contactId);
        OutJson.print(request, response, dataList);
    }

    protected void doRemarkSave(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        ContactRemark contactRemark = RequestToBeanUtil.autoSet(request, ContactRemark.class);
        contactRemark.setId(UUIDGenerator.generate());
        contactRemark.setCreateTime(DateUtil.getSysTime());
        Map<String, Object> map = contactService.saveRemark(contactRemark);
        OutJson.print(request, response, map);
    }

    protected void getDetail(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = contactService.getDetail(id);
        request.setAttribute("map", map);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request, response);
    }

    protected void doImport(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Contact> dataList = new ArrayList<>();
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
                        ReadExcel<Contact> readExcel = new ReadExcel<>();
                        dataList = readExcel.doRead(item.getInputStream(), Contact.class, dataList);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        boolean flag = false;
        Map<String, Boolean> map = new HashMap<>();
        if (dataList.size() != 0) {
            flag = contactService.doImport(dataList);
        }
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doExportCheckAll(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        String[] excelHeader = {"id#id", "所有者#owner", "来源#source", "称呼#appellation", "姓名#name", "职位#job", "手机号#mphone", "邮箱#email", "生日#birth", "客户Id#customerId", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "地址#address", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Contact> dataList = contactService.getCheckAllContact(id);
        String className = "联系人表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doExportAll(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String[] excelHeader = {"id#id", "所有者#owner", "来源#source", "称呼#appellation", "姓名#name", "职位#job", "手机号#mphone", "邮箱#email", "生日#birth", "客户Id#customerId", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "地址#address", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Contact> dataList = contactService.getAllContact();
        String className = "联系人表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        boolean flag = contactService.doDelete(id);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        Contact contact = RequestToBeanUtil.autoSet(request, Contact.class);
        contact.setEditTime(DateUtil.getSysTime());
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", contactService.update(contact));
        OutJson.print(request, response, map);
    }

    protected void doGetOne(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = contactService.getOne(id);
        OutJson.print(request, response, map);
    }

    protected void doPage(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        Integer pageSize = Integer.valueOf(request.getParameter("pageSize"));
        Integer pageNo = Integer.valueOf(request.getParameter("pageNo"));
        String name = request.getParameter("name");
        String birth = request.getParameter("birth");
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String customerName = request.getParameter("customerName");


        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("birth", birth);
        map.put("owner", owner);
        map.put("source", source);
        map.put("customerName", customerName);
        map.put("pageIndex", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        PaginationVO<Map<String, Object>> page = contactService.page(map);
        OutJson.print(request, response, page);
    }

    protected void getByName(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String name = request.getParameter("name");
        List<Contact> dataList = contactService.getByName(name);
        OutJson.print(request, response, dataList);
    }

    protected void doSave(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        Contact contact = RequestToBeanUtil.autoSet(request, Contact.class);
        contact.setId(UUIDGenerator.generate());
        contact.setCreateTime(DateUtil.getSysTime());
        boolean flag = contactService.doSave(contact);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }
}
