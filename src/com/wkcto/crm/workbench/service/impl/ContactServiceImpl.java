package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.utils.Const;
import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.dao.ContactDao;
import com.wkcto.crm.workbench.dao.ContactRemarkDao;
import com.wkcto.crm.workbench.domain.Contact;
import com.wkcto.crm.workbench.domain.ContactRemark;
import com.wkcto.crm.workbench.service.ContactService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContactServiceImpl implements ContactService {
    private ContactDao contactDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ContactDao.class);
    private ContactRemarkDao contactRemarkDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ContactRemarkDao.class);

    @Override
    public boolean doSave(Contact contact) {
        return contactDao.save(contact) == 1;
    }

    @Override
    public List<Contact> getContactByCustomerId(String customerId) {
        return contactDao.getContactByCustomerId(customerId);
    }

    @Override
    public boolean delContactById(String id) {
        return contactDao.delContact(id) == 1;
    }

    @Override
    public List<Contact> getByName(String name) {
        return contactDao.getByName(name);
    }

    @Override
    public PaginationVO<Map<String, Object>> page(Map<String, Object> map) {
        PaginationVO<Map<String, Object>> page1 = new PaginationVO<>();
        page1.setTotal(contactDao.getPageTotal(map));
        page1.setaList(contactDao.getList(map));
        return page1;
    }

    @Override
    public Map<String, Object> getOne(String id) {
        return contactDao.getOne(id);
    }

    @Override
    public Boolean update(Contact contact) {
        return contactDao.update(contact) == 1;
    }

    @Override
    public boolean doDelete(String[] id) {
        return (contactDao.delete(id)) >= 1 && (contactRemarkDao.delByContactIdArray(id)) >= 0;
    }

    @Override
    public List<Contact> getAllContact() {
        return contactDao.getAllContact();
    }

    @Override
    public List<Contact> getCheckAllContact(String[] id) {
        return contactDao.getCheckAllContact(id);
    }

    @Override
    public boolean doImport(List<Contact> dataList) {
        return (contactDao.doImport(dataList)) >= 1;
    }

    @Override
    public Map<String, Object> getDetail(String id) {
        return contactDao.getOne(id);
    }

    @Override
    public Map<String, Object> saveRemark(ContactRemark contactRemark) {
        Map<String,Object> map = new HashMap<>();
        map.put("contactRemark",contactRemark);
        map.put("success",contactRemarkDao.saveOne(contactRemark) == 1);
        return map;
    }

    @Override
    public List<ContactRemark> getRemarkListByContactId(String contactId) {
        return contactRemarkDao.getListByContactId(contactId);
    }

    @Override
    public Map<String, Object> updateRemark(ContactRemark contactRemark) {
        Map<String,Object> map = new HashMap<>();
        if (contactRemarkDao.update(contactRemark) == 1){
            map.put("success",contactRemarkDao.update(contactRemark) == 1);
            map.put("noteContent",contactRemark.getNoteContent());
            map.put("editBy",contactRemark.getEditBy());
            map.put("editTime",contactRemark.getEditTime());
        }
        return map;
    }

    @Override
    public boolean deleteRemark(String id) {
        return contactRemarkDao.delete(id) == 1;
    }

    @Override
    public List<Map<String, Object>> getAlertMsg() {
        String nowTime = new SimpleDateFormat(Const.DATE_DAY_FORMAT).format(new Date());
        return contactDao.getAlertMsg(nowTime);
    }
}
