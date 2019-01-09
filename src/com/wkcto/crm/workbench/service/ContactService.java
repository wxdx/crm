package com.wkcto.crm.workbench.service;

import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.Contact;
import com.wkcto.crm.workbench.domain.ContactRemark;

import java.util.List;
import java.util.Map;

public interface ContactService {
    /**
     * 保存联系人
     * @param contact
     * @return
     */
    boolean doSave(Contact contact);

    /**
     * 通过客户Id查询联系人
     * @param customerId
     * @return
     */
    List<Contact> getContactByCustomerId(String customerId);

    /**
     * 通过Id删除联系人
     * @param id
     * @return
     */
    boolean delContactById(String id);

    /**
     * 通过姓名查联系人
     * @param name
     * @return
     */
    List<Contact> getByName(String name);

    /**
     * 分页查询
     * @param map
     * @return
     */
    PaginationVO<Map<String, Object>> page(Map<String, Object> map);

    /**
     * 根据Id查单条记录
     * @param id
     * @return
     */
    Map<String, Object> getOne(String id);

    /**
     * 更新联系人
     * @param contact
     * @return
     */
    Boolean update(Contact contact);

    /**
     * 删除联系人
     * @param id
     * @return
     */
    boolean doDelete(String[] id);

    /**
     * 获取所有联系人信息
     * @return
     */
    List<Contact> getAllContact();

    /**
     * 获取选中的联系人信息
     * @param id
     * @return
     */
    List<Contact> getCheckAllContact(String[] id);

    /**
     * 导入联系人
     * @param dataList
     * @return
     */
    boolean doImport(List<Contact> dataList);

    /**
     * 获取详情页数据
     * @param id
     * @return
     */
    Map<String, Object> getDetail(String id);

    /**
     * 保存备注
     * @param contactRemark
     * @return
     */
    Map<String, Object> saveRemark(ContactRemark contactRemark);

    /**
     * 根据联系人Id 获取该联系人备注
     * @param contactId
     * @return
     */
    List<ContactRemark> getRemarkListByContactId(String contactId);

    /**
     * 修改联系人备注
     * @param contactRemark
     * @return
     */
    Map<String, Object> updateRemark(ContactRemark contactRemark);

    /**
     * 删除备注
     * @param id
     * @return
     */
    boolean deleteRemark(String id);

    /**
     * 获取每日提醒信息
     * @return
     */
    List<Map<String, Object>> getAlertMsg();
}
