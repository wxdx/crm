package com.wkcto.crm.workbench.dao;


import com.wkcto.crm.workbench.domain.ContactActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactActivityRelationDao {
    void save(List<ContactActivityRelation> carList);

    List<Map<String,Object>> getActivityByContactId(String contactId);

    int doDissociatedById(String id);

    int relation(List<ContactActivityRelation> dataList);
}
