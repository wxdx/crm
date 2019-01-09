package com.wkcto.crm.workbench.service;

import com.wkcto.crm.workbench.domain.Activity;
import com.wkcto.crm.workbench.domain.ContactActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactActivityRelationService {
    /**
     * 通过联系人Id查市场活动
     * @param contactId
     * @return
     */
    List<Map<String,Object>> getActivityByContactId(String contactId);

    /**
     * 解除关联
     * @param id
     * @return
     */
    boolean doDissociatedById(String id);

    /**
     * 关联市场活动和联系人
     * @param dataList
     * @return
     */
    boolean relationContactAndActivity(List<ContactActivityRelation> dataList);
}
