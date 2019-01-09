package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
    int save(Tran tran);

    List<Map<String, Object>> getByCustomerId(String customerId);

    int delById(String id);


    List<Map<String, Object>> getByContactsId(String contactsId);

    List<Map<String, Object>> getList(Map<String, Object> map);

    Long getPageTotal(Map<String, Object> map);

    Map<String, Object> getOneById(String id);

    int doUpdate(Tran tran);

    int delete(String[] id);

    List<Tran> getAllTran();

    List<Tran> getCheckAllTran(String[] id);

    int doImport(List<Tran> dataList);

    int updateStage(Tran tran);
}
