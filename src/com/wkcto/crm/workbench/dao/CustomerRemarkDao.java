package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {
    void save(List<CustomerRemark> customerRemarkList);

    int delByCustomerIdArray(String[] id);

    List<CustomerRemark> getRemarkByCustomerId(String customerId);

    int saveOne(CustomerRemark customerRemark);

    int update(CustomerRemark customerRemark);

    int deleteById(String id);
}
