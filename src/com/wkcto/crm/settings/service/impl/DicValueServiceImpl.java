package com.wkcto.crm.settings.service.impl;

import com.wkcto.crm.settings.dao.DicTypeDao;
import com.wkcto.crm.settings.dao.DicValueDao;
import com.wkcto.crm.settings.domain.DicType;
import com.wkcto.crm.settings.service.DicValueService;
import com.wkcto.crm.settings.domain.DicValue;
import com.wkcto.crm.utils.SqlSeesionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicValueServiceImpl implements DicValueService {
    private DicValueDao dicValueDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(DicValueDao.class);
    private DicTypeDao dicTypeDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(DicTypeDao.class);
    @Override
    public List<Map<String, String>> getType() {
        return dicValueDao.getType();
    }

    @Override
    public int doSave(DicValue dicValue) {
        return dicValueDao.doSave(dicValue);
    }

    @Override
    public List<DicValue> getList() {
        return dicValueDao.getList();
    }

    @Override
    public DicValue getOne(String id) {
        return dicValueDao.getOne(id);
    }

    @Override
    public int doUpdate(DicValue dicValue) {
        return dicValueDao.doUpdate(dicValue);
    }

    @Override
    public int doDelete(String[] id) {
        return dicValueDao.doDelete(id);
    }

    @Override
    public int checkValue(String typeCode,String value) {
        return dicValueDao.checkVlaue(typeCode,value);
    }

    @Override
    public Map<String, String> getTypeName(String typeCode1) {
        return dicValueDao.getTypeName(typeCode1);
    }

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String,List<DicValue>> map = new HashMap<>();
        List<DicType> dicTypes = dicTypeDao.doGetTypeList();
        for (DicType dicType:dicTypes){
            String code = dicType.getCode();
            List<DicValue> a =  dicValueDao.getByTypeCode(code);
            map.put( code +"List",a);
        }
        return map;
    }


}
