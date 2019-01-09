package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    List<ClueRemark> getClueRemarkByClueId(String clueId);

    void delByClueId(String clueId);

    int delByClueIdArray(String[] id);
}
