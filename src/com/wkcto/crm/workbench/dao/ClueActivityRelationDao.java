package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {
    List<Map<String,Object>> getActivityByClueId(String clueId);

    int relationClueAndActivity(List<ClueActivityRelation> dataList);

    int doDissociatedById(String id);

    List<String> getActivityIdByClueId(String clueId);

    void delByClueId(String clueId);
}
