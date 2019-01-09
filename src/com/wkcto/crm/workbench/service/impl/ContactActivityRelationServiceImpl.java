package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.workbench.dao.ContactActivityRelationDao;
import com.wkcto.crm.workbench.domain.ContactActivityRelation;
import com.wkcto.crm.workbench.service.ContactActivityRelationService;

import java.util.List;
import java.util.Map;

/**
 *
 */
public class ContactActivityRelationServiceImpl implements ContactActivityRelationService {
    private ContactActivityRelationDao crd = SqlSeesionUtil.getCurrentSqlSession().getMapper(ContactActivityRelationDao.class);
    @Override
    public List<Map<String, Object>> getActivityByContactId(String contactId) {
        return crd.getActivityByContactId(contactId);
    }

    @Override
    public boolean doDissociatedById(String id) {
        return crd.doDissociatedById(id) == 1;
    }

    @Override
    public boolean relationContactAndActivity(List<ContactActivityRelation> dataList) {
        return (crd.relation(dataList)) >= 1;
    }
}
