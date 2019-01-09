package com.wkcto.crm.settings.service.impl;

import com.wkcto.crm.settings.dao.DicTypeDao;
import com.wkcto.crm.settings.service.DicTypeService;
import com.wkcto.crm.settings.domain.DicType;
import com.wkcto.crm.utils.SqlSeesionUtil;

import java.util.List;
import java.util.Map;

public class DicTypeServiceImpl implements DicTypeService {
    private DicTypeDao dicTypeDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(DicTypeDao.class);
    @Override
    public Integer doCheckCode(String code) {
        return dicTypeDao.doCheckCode(code);
    }

    @Override
    public int doSave(DicType dicType) {
        return dicTypeDao.doSave(dicType);
    }

    @Override
    public List<DicType> doGetTypeList() {
        return dicTypeDao.doGetTypeList();
    }

    @Override
    public DicType doGetOne(String code) {
        return dicTypeDao.doGetOne(code);
    }

    @Override
    public int doUpdate(Map<String,String> map) {
        return dicTypeDao.doUpdate(map);
    }

    @Override
    public int doDelete(String[] code) {
        return dicTypeDao.doDelete(code);
    }

}
