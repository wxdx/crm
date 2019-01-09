package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    void save(List<TranRemark> tranRemarkList);

    int delByTranIdArray(String[] id);

    List<TranRemark> getListByTranId(String tranId);

    int saveOne(TranRemark tranRemark);

    int update(TranRemark tranRemark);

    int delete(String id);
}
