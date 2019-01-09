package com.wkcto.crm.workbench.service;

import com.wkcto.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {
    /**
     * 通过线索Id获取市场活动
     * @param clueId
     * @return
     */
    List<Map<String,Object>> getActivityByClueId(String clueId);

    /**
     * 关联线索和市场活动
     * @param dataList
     * @return
     */
    boolean relationClueAndActivity(List<ClueActivityRelation> dataList);

    /**
     * 通过线索市场活动表的Id解除关联
     * @param id
     * @return
     */
    boolean doDissociatedById(String id);
}
