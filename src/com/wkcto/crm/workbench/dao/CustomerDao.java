package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.Clue;
import com.wkcto.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {
    Customer getByName(String company);

    int save(Customer customer);

    Long getTotal(Map<String, Object> map);

    List<Clue> getPageList(Map<String, Object> map);

    Map<String, Object> getById(String id);

    int update(Customer customer);

    int delete(String[] id);

    List<Customer> getAllCustomer();

    List<Customer> getCheckAllCustomer(String[] id);

    int doImport(List<Customer> dataList);

    Customer doCheckByName(String name);

    List<String> getMatchNameByName(String name);
}
