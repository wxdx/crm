package com.wkcto.crm.workbench.controller;

import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.utils.*;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.Clue;
import com.wkcto.crm.workbench.domain.Contact;
import com.wkcto.crm.workbench.domain.Customer;
import com.wkcto.crm.workbench.domain.CustomerRemark;
import com.wkcto.crm.workbench.service.ContactService;
import com.wkcto.crm.workbench.service.CustomerService;
import com.wkcto.crm.workbench.service.impl.ContactServiceImpl;
import com.wkcto.crm.workbench.service.impl.CustomerServiceImpl;
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
 * 客户控制器
 */
public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        String path = request.getServletPath();
        CustomerService customerService = (CustomerService) new TransactionInvocationHandler(new CustomerServiceImpl()).getProxy();
        ContactService contactService = (ContactService) new TransactionInvocationHandler(new ContactServiceImpl()).getProxy();

        if ("/workbench/customer/page.do".equals(path)) {
            doPage(request, response, customerService);
        } else if ("/workbench/customer/save.do".equals(path)) {
            doSave(request, response, customerService);
        } else if ("/workbench/customer/getOne.do".equals(path)) {
            getOne(request, response, customerService);
        } else if ("/workbench/customer/update.do".equals(path)) {
            doUpdate(request, response, customerService);
        } else if ("/workbench/customer/delete.do".equals(path)) {
            doDelete(request, response, customerService);
        } else if ("/workbench/customer/exportAll.do".equals(path)) {
            doExportAll(request, response, customerService);
        } else if ("/workbench/customer/exportCheckAll.do".equals(path)) {
            doExportCheckAll(request, response, customerService);
        } else if ("/workbench/customer/import.do".equals(path)) {
            doImport(request, response, customerService);
        } else if ("/workbench/customer/detail.do".equals(path)) {
            doDetail(request, response, customerService);
        } else if ("/workbench/customer/getRemarkList.do".equals(path)) {
            doGetRemarkList(request, response, customerService);
        } else if ("/workbench/customer/remarkSave.do".equals(path)) {
            doRemarkSave(request, response, customerService);
        } else if ("/workbench/customer/updateRemark.do".equals(path)) {
            doRemarkUpdate(request, response, customerService);
        } else if ("/workbench/customer/deleteRemark.do".equals(path)) {
            doRemarkDelete(request, response, customerService);
        } else if ("/workbench/customer/checkCustomerName.do".equals(path)) {
            doCheckCustomerName(request, response, customerService);
        } else if ("/workbench/customer/getContact.do".equals(path)) {
            doGetContact(request, response, contactService);
        } else if ("/workbench/customer/delContact.do".equals(path)) {
            doDelContact(request, response, contactService);
        }
    }

    protected void doDelContact(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String id = request.getParameter("id");
        boolean flag = contactService.delContactById(id);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doGetContact(HttpServletRequest request, HttpServletResponse response, ContactService contactService) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");
        List<Contact> dataList = contactService.getContactByCustomerId(customerId);
        OutJson.print(request, response, dataList);
    }

    protected void doCheckCustomerName(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String name = request.getParameter("name");
        String operator = ((User) request.getSession().getAttribute(Const.Session_User)).getName();
        String owner = ((User) request.getSession().getAttribute(Const.Session_User)).getId();
        Map<String, Object> map = customerService.doCheckByName(name, operator, owner);
        OutJson.print(request, response, map);
    }

    protected void doRemarkDelete(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", customerService.deleteRemarkById(id) == 1);
        OutJson.print(request, response, map);
    }

    protected void doRemarkUpdate(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        CustomerRemark customerRemark = RequestToBeanUtil.autoSet(request, CustomerRemark.class);
        customerRemark.setEditTime(DateUtil.getSysTime());
        Map<String, Object> map = customerService.doRemarkUpdate(customerRemark);
        OutJson.print(request, response, map);
    }

    protected void doRemarkSave(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        CustomerRemark customerRemark = RequestToBeanUtil.autoSet(request, CustomerRemark.class);
        customerRemark.setId(UUIDGenerator.generate());
        customerRemark.setCreateTime(DateUtil.getSysTime());

        Map<String, Object> map = customerService.doRemarkSave(customerRemark);
        OutJson.print(request, response, map);
    }

    protected void doGetRemarkList(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String customerId = request.getParameter("customerId");
        List<CustomerRemark> dataList = customerService.getRemarkListByCustomerId(customerId);
        OutJson.print(request, response, dataList);
    }

    protected void doDetail(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = customerService.getDetail(id);
        request.setAttribute("map", map);
        request.getRequestDispatcher("detail.jsp").forward(request, response);
    }

    protected void doImport(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Customer> dataList = new ArrayList<>();
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
                        ReadExcel<Customer> readExcel = new ReadExcel<>();
                        dataList = readExcel.doRead(item.getInputStream(), Customer.class, dataList);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        boolean flag = false;
        Map<String, Boolean> map = new HashMap<>();
        if (dataList.size() != 0) {
            flag = customerService.doImport(dataList);
        }
        map.put("success", flag);
        OutJson.print(request, response, map);

    }

    protected void doExportCheckAll(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        String[] excelHeader = {"id#id", "所有者#owner", "名称#name", "公司电话#phone", "公司网站#website", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "详细地址#address", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Customer> dataList = customerService.getCheckAllCustomer(id);
        String className = "客户表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    protected void doExportAll(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String[] excelHeader = {"id#id", "所有者#owner", "名称#name", "公司电话#phone", "公司网站#website", "描述#description", "联系纪要#contactSummary", "下次联系时间#nextContactTime", "详细地址#address", "创建人#createBy", "创建时间#createTime", "修改人#editBy", "修改时间#editTime"};
        List<Customer> dataList = customerService.getAllCustomer();
        String className = "客户表";
        try {
            ExportExcel2010Util.export(response, className, excelHeader, dataList);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String[] id = request.getParameterValues("id");
        boolean flag = customerService.doDelete(id);
        if (flag) {
            response.sendRedirect(request.getContextPath() + "/workbench/customer/index.jsp");
        }

    }

    protected void doUpdate(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        Customer customer = RequestToBeanUtil.autoSet(request, Customer.class);
        customer.setEditTime(DateUtil.getSysTime());
        boolean flag = customerService.doUpdate(customer);
        if (flag) {
            response.sendRedirect(request.getContextPath() + "/workbench/customer/index.jsp");
        }
    }

    protected void getOne(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        String id = request.getParameter("id");
        Map<String, Object> map = customerService.getDetail(id);
        OutJson.print(request, response, map);
    }

    protected void doSave(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        Customer customer = RequestToBeanUtil.autoSet(request, Customer.class);
        customer.setId(UUIDGenerator.generate());
        customer.setCreateTime(DateUtil.getSysTime());

        boolean flag = customerService.save(customer);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        OutJson.print(request, response, map);
    }

    protected void doPage(HttpServletRequest request, HttpServletResponse response, CustomerService customerService) throws ServletException, IOException {
        Integer pageSize = Integer.valueOf(request.getParameter("pageSize"));
        Integer pageNo = Integer.valueOf(request.getParameter("pageNo"));
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String owner = request.getParameter("owner");
        String website = request.getParameter("website");


        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("phone", phone);
        map.put("owner", owner);
        map.put("website", website);
        map.put("pageIndex", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        PaginationVO<Clue> page = customerService.page(map);
        OutJson.print(request, response, page);
    }
}
