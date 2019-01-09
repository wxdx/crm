package com.wkcto.crm.settings.service.impl;

import com.wkcto.crm.settings.dao.DeptDao;
import com.wkcto.crm.settings.service.DeptService;
import com.wkcto.crm.settings.domain.Dept;
import com.wkcto.crm.utils.SqlSeesionUtil;

import java.util.List;
import java.util.Map;

/**
 *
 */
public class DeptServiceImpl implements DeptService {
    private DeptDao deptDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(DeptDao.class);
    @Override
    public int doSave(Dept dept) {
        return deptDao.doSave(dept);
    }

    @Override
    public int doCheck(String deptno) {
        return deptDao.doCheck(deptno);
    }

    @Override
    public List<Dept> doGetList() {
        return deptDao.doGetList();
    }

    @Override
    public Dept doGetOne(String deptno) {
        return deptDao.doGetOne(deptno);
    }

    @Override
    public int doUpdate(Map<String, String> map) {
        return deptDao.doUpdate(map);
    }

    @Override
    public int doDelete(String[] deptno) {
        return deptDao.doDelete(deptno);
    }

    @Override
    public List<Dept> getListForUser() {
        return deptDao.getDeptList();
    }
}
