package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.Contact;

import java.util.List;
import java.util.Map;

public interface ContactDao {
    int save(Contact contact);

    List<Contact> getContactByCustomerId(String customerId);

    int delContact(String id);

    List<Contact> getByName(String name);

    List<Map<String, Object>> getList(Map<String, Object> map);

    Long getPageTotal(Map<String, Object> map);

    Map<String, Object> getOne(String id);

    int update(Contact contact);

    int delete(String[] id);

    List<Contact> getAllContact();

    List<Contact> getCheckAllContact(String[] id);

    int doImport(List<Contact> dataList);

    List<Map<String, Object>> getAlertMsg(String nowTime);
}
