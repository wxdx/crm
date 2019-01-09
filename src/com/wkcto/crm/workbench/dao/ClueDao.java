package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.Clue;
import com.wkcto.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int doSave(Clue clue);

    Long getTotal(Map<String, Object> map);

    List<Clue> getPageList(Map<String, Object> map);

    Map<String,Object> getById(String id);

    int update(Clue clue);

    int delete(String[] id);

    List<Clue> getAllClue();

    List<Clue> getCheckClue(String[] id);

    int doImport(List<Clue> dataList);

    List<ClueRemark> getRemarkList(String clueId);

    int doRemarkSave(ClueRemark clueRemark);

    int updateRemark(ClueRemark clueRemark);

    int deleteRemark(String id);

    Clue getById2(String clueId);

    void delById(String clueId);
}
