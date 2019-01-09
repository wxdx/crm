package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.workbench.dao.ChartDao;
import com.wkcto.crm.workbench.service.ChartService;

import java.util.List;
import java.util.Map;

public class ChartServiceImpl implements ChartService {
    private ChartDao chartDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ChartDao.class);
    @Override
    public List<Map<String, Object>> getTranChart() {
        return chartDao.getTranChart();
    }
}
