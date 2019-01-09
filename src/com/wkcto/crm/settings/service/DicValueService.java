package com.wkcto.crm.settings.service;

import com.wkcto.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicValueService {
    List<Map<String, String>> getType();

    int doSave(DicValue dicValue);


    List<DicValue> getList();

    DicValue getOne(String id);

    int doUpdate(DicValue dicValue);

    int doDelete(String[] id);

    int checkValue(String typeCode,String value);

    Map<String, String> getTypeName(String typeCode1);

    Map<String, List<DicValue>> getAll();
}
