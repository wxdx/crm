package com.wkcto.crm.workbench.service;

import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.Clue;
import com.wkcto.crm.workbench.domain.Customer;
import com.wkcto.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    /**
     * 分页查询
     * @param map
     * @return
     */
    PaginationVO<Clue> page(Map<String, Object> map);

    /**
     * 保存客户
     * @param customer
     * @return
     */
    boolean save(Customer customer);

    /**
     * 获取详情页数据
     * @param id
     * @return
     */

    Map<String, Object> getDetail(String id);

    /**
     * 更新
     * @param customer
     * @return
     */

    boolean doUpdate(Customer customer);

    /**
     * 删除
     * @param id
     * @return
     */

    boolean doDelete(String[] id);

    /**
     * 获取所有的客户
     * @return
     */

    List<Customer> getAllCustomer();

    /**
     * 获取选中的客户
     * @param id
     * @return
     */

    List<Customer> getCheckAllCustomer(String[] id);

    /**
     * 导入
     * @param dataList
     * @return
     */

    boolean doImport(List<Customer> dataList);

    /**
     * 通过Id获取备注列表
     * @param customerId
     * @return
     */

    List<CustomerRemark> getRemarkListByCustomerId(String customerId);

    /**
     * 备注保存
     * @param customerRemark
     * @return
     */

    Map<String, Object> doRemarkSave(CustomerRemark customerRemark);

    /**
     * 备注更新
     * @param customerRemark
     * @return
     */

    Map<String, Object> doRemarkUpdate(CustomerRemark customerRemark);

    /**
     * 删除备注
     * @param id
     * @return
     */

    int deleteRemarkById(String id);

    /**
     * 判断客户是否存在,是否新建
     * @param name
     * @param operator
     * @param owner
     * @return
     */

    Map<String,Object> doCheckByName(String name,String operator,String owner);

    /**
     * 通过输入的Name获取匹配的客户Name
     * @param name
     * @return
     */
    List<String> getMatchNameByName(String name);
}
