package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.utils.Const;
import com.wkcto.crm.utils.DateUtil;
import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.utils.UUIDGenerator;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.dao.CustomerDao;
import com.wkcto.crm.workbench.dao.CustomerRemarkDao;
import com.wkcto.crm.workbench.domain.Clue;
import com.wkcto.crm.workbench.domain.Customer;
import com.wkcto.crm.workbench.domain.CustomerRemark;
import com.wkcto.crm.workbench.service.CustomerService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(CustomerRemarkDao.class);
    @Override
    public PaginationVO<Clue> page(Map<String, Object> map) {
        PaginationVO<Clue> page1 = new PaginationVO<>();
        page1.setTotal(customerDao.getTotal(map));
        page1.setaList(customerDao.getPageList(map));
        return page1;
    }

    @Override
    public boolean save(Customer customer) {
        return customerDao.save(customer) == 1;
    }

    @Override
    public Map<String, Object> getDetail(String id) {
        return customerDao.getById(id);
    }

    @Override
    public boolean doUpdate(Customer customer) {
        return customerDao.update(customer) == 1;
    }

    @Override
    public boolean doDelete(String[] id) {
        boolean flag = false;
        if ((customerDao.delete(id)) >= 1 && (customerRemarkDao.delByCustomerIdArray(id)) >= 0){
            flag = true;
        }
        return flag;
    }

    @Override
    public List<Customer> getAllCustomer() {
        return customerDao.getAllCustomer();
    }

    @Override
    public List<Customer> getCheckAllCustomer(String[] id) {
        return customerDao.getCheckAllCustomer(id);
    }

    @Override
    public boolean doImport(List<Customer> dataList) {
        return (customerDao.doImport(dataList)) >= 1;
    }

    @Override
    public List<CustomerRemark> getRemarkListByCustomerId(String customerId) {
        return customerRemarkDao.getRemarkByCustomerId(customerId);
    }

    @Override
    public Map<String, Object> doRemarkSave(CustomerRemark customerRemark) {
        Map<String,Object> map = new HashMap<>();
        map.put("customerRemark",customerRemark);
        map.put("success",customerRemarkDao.saveOne(customerRemark) == 1);
        return map;
    }

    @Override
    public Map<String, Object> doRemarkUpdate(CustomerRemark customerRemark) {
        Map<String,Object> map = new HashMap<>();
        if (customerRemarkDao.update(customerRemark) == 1){
            map.put("success",customerRemarkDao.update(customerRemark) == 1);
            map.put("noteContent",customerRemark.getNoteContent());
            map.put("editBy",customerRemark.getEditBy());
            map.put("editTime",customerRemark.getEditTime());
        }
        return map;
    }

    @Override
    public int deleteRemarkById(String id) {
        return customerRemarkDao.deleteById(id);
    }

    @Override
    public Map<String,Object> doCheckByName(String name,String operator,String owner) {
        Customer customer = customerDao.doCheckByName(name);
        Map<String,Object> map = new HashMap<>();
        if (customer != null){
            map.put("success",true);
            map.put("id",customer.getId());
            return map;
        } else {
            Customer customer1 = new Customer();
            customer1.setId(UUIDGenerator.generate());
            customer1.setOwner(owner);
            customer1.setCreateBy(operator);
            customer1.setCreateTime(DateUtil.getSysTime());
            customer1.setName(name);
            int i = customerDao.save(customer1);
            if (i == 1) {
                map.put("success",true);
                map.put("id",customer1.getId());
                return map;
            } else {
                map.put("success",false);
                return map;
            }
        }
    }

    @Override
    public List<String> getMatchNameByName(String name) {
        return customerDao.getMatchNameByName(name);
    }
}
