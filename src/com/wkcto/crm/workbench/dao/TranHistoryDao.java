package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {
    int save(TranHistory th);

    List<TranHistory> getList(String tranId);

    int delByTranIdArray(String[] id);
}
