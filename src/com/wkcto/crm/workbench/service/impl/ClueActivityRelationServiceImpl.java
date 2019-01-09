package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.workbench.dao.ClueActivityRelationDao;
import com.wkcto.crm.workbench.domain.ClueActivityRelation;
import com.wkcto.crm.workbench.service.ClueActivityRelationService;

import java.util.List;
import java.util.Map;

public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    ClueActivityRelationDao clueActivityRelationDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ClueActivityRelationDao.class);
    @Override
    public List<Map<String,Object>> getActivityByClueId(String clueId) {
        return clueActivityRelationDao.getActivityByClueId(clueId);
    }

    @Override
    public boolean relationClueAndActivity(List<ClueActivityRelation> dataList) {
        return clueActivityRelationDao.relationClueAndActivity(dataList) >= 1;
    }

    @Override
    public boolean doDissociatedById(String id) {
        return clueActivityRelationDao.doDissociatedById(id) == 1;
    }
}
