package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.utils.UUIDGenerator;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.dao.TranDao;
import com.wkcto.crm.workbench.dao.TranHistoryDao;
import com.wkcto.crm.workbench.dao.TranRemarkDao;
import com.wkcto.crm.workbench.domain.Tran;
import com.wkcto.crm.workbench.domain.TranHistory;
import com.wkcto.crm.workbench.domain.TranRemark;
import com.wkcto.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class TranServiceImpl implements TranService {
    private TranDao tranDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao  = SqlSeesionUtil.getCurrentSqlSession().getMapper(TranHistoryDao .class);
    private TranRemarkDao tranRemarkDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(TranRemarkDao.class);

    @Override
    public boolean doSave(Tran tran) {
        TranHistory th = new TranHistory();
        th.setId(UUIDGenerator.generate());
        th.setStage(tran.getStage());
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setCreateTime(tran.getCreateTime());
        th.setCreateBy(tran.getCreateBy());
        th.setTranId(tran.getId());
        return tranDao.save(tran) == 1 && tranHistoryDao.save(th) == 1;
    }

    @Override
    public List<Map<String, Object>> getByCustomerId(String customerId) {
        return tranDao.getByCustomerId(customerId);
    }

    @Override
    public boolean delById(String id) {
        return tranDao.delById(id) == 1;
    }

    @Override
    public List<Map<String, Object>> getByContactsId(String contactsId) {
        return tranDao.getByContactsId(contactsId);
    }

    @Override
    public PaginationVO<Map<String, Object>> page(Map<String, Object> map) {
        PaginationVO<Map<String, Object>> page1 = new PaginationVO<>();
        page1.setTotal(tranDao.getPageTotal(map));
        page1.setaList(tranDao.getList(map));
        return page1;
    }

    @Override
    public Map<String, Object> getOneById(String id) {
        return tranDao.getOneById(id);
    }

    @Override
    public boolean doUpdate(Tran tran) {
        return tranDao.doUpdate(tran) == 1;
    }

    @Override
    public boolean doDelete(String[] id) {
        return (tranDao.delete(id)) >= 1 && (tranRemarkDao.delByTranIdArray(id)) >= 0 && (tranHistoryDao.delByTranIdArray(id)) >= 0;
    }

    @Override
    public List<Tran> getAllTran() {
        return tranDao.getAllTran();
    }

    @Override
    public List<Tran> getCheckAllTran(String[] id) {
        return tranDao.getCheckAllTran(id);
    }

    @Override
    public boolean doImport(List<Tran> dataList) {
        return (tranDao.doImport(dataList)) >= 1;
    }

    @Override
    public List<TranHistory> getHistoryList(String tranId) {
        return tranHistoryDao.getList(tranId);
    }

    @Override
    public boolean updateStage(Tran tran) {
        TranHistory th = new TranHistory();
        th.setId(UUIDGenerator.generate());
        th.setCreateBy(tran.getEditBy());
        th.setCreateTime(tran.getEditTime());
        th.setMoney(tran.getMoney());
        th.setStage(tran.getStage());
        th.setTranId(tran.getId());
        th.setExpectedDate(tran.getExpectedDate());
        return tranDao.updateStage(tran) == 1 && tranHistoryDao.save(th) == 1;
    }

    @Override
    public List<TranRemark> getRemarkList(String tranId) {
        return tranRemarkDao.getListByTranId(tranId);
    }

    @Override
    public Map<String,Object> saveRemark(TranRemark tranRemark) {
        Map<String,Object> map = new HashMap<>();
        map.put("tranRemark",tranRemark);
        map.put("success",tranRemarkDao.saveOne(tranRemark) == 1);
        return map;
    }

    @Override
    public Map<String, Object> updateRemark(TranRemark tranRemark) {
        Map<String,Object> map = new HashMap<>();
        if (tranRemarkDao.update(tranRemark) == 1){
            map.put("success",tranRemarkDao.update(tranRemark) == 1);
            map.put("noteContent",tranRemark.getNoteContent());
            map.put("editBy",tranRemark.getEditBy());
            map.put("editTime",tranRemark.getEditTime());
        }
        return map;
    }

    @Override
    public boolean deleteRemark(String id) {
        return tranRemarkDao.delete(id) == 1;
    }
}
