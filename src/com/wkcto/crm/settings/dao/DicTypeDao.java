package com.wkcto.crm.settings.dao;


import com.wkcto.crm.settings.domain.DicType;

import java.util.List;
import java.util.Map;

public interface DicTypeDao {
    Integer doCheckCode(String code);

    int doSave(DicType dicType);

    List<DicType> doGetTypeList();

    DicType doGetOne(String code);

    int doUpdate(Map<String, String> map);

    int doDelete(String[] code);

}
