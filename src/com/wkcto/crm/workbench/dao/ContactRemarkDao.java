package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.ContactRemark;

import java.util.List;

public interface ContactRemarkDao {
    void save(List<ContactRemark> contactRemarkList);

    int delByContactIdArray(String[] id);

    int saveOne(ContactRemark contactRemark);

    List<ContactRemark> getListByContactId(String contactId);

    int update(ContactRemark contactRemark);

    int delete(String id);
}
