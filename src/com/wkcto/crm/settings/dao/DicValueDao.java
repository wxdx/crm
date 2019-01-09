package com.wkcto.crm.settings.dao;

import com.wkcto.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicValueDao {

    List<Map<String, String>> getType();

    int doSave(DicValue dicValue);

    List<DicValue> getList();

    DicValue getOne(String id);

    int doUpdate(DicValue dicValue);

    int doDelete(String[] id);

    int checkVlaue(String typeCode,String value);

    Map<String, String> getTypeName(String typeCode1);

    List<DicValue> getByTypeCode(String appellation);
}
