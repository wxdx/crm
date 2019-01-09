package com.wkcto.crm.workbench.service;

import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.Contact;
import com.wkcto.crm.workbench.domain.Tran;
import com.wkcto.crm.workbench.domain.TranHistory;
import com.wkcto.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranService {
    /**
     * 保存交易
     * @param tran
     * @return
     */
    boolean doSave(Tran tran);

    /**
     * 通过客户Id查询交易
     * @param customerId
     * @return
     */
    List<Map<String, Object>> getByCustomerId(String customerId);

    /**
     * 通过Id删除交易
     * @param id
     * @return
     */
    boolean delById(String id);

    /**
     * 通过联系人Id查询交易
     * @param contactsId
     * @return
     */
    List<Map<String, Object>> getByContactsId(String contactsId);

    /**
     * 分页查询
     * @param map
     * @return
     */
    PaginationVO<Map<String, Object>> page(Map<String, Object> map);

    /**
     * 通过Id查询单条
     * @param id
     * @return
     */
    Map<String, Object> getOneById(String id);

    /**
     * 更新交易
     * @param tran
     * @return
     */
    boolean doUpdate(Tran tran);

    /**
     * 删除交易
     * @param id
     * @return
     */
    boolean doDelete(String[] id);

    /**
     * 获取全部交易
     * @return
     */
    List<Tran> getAllTran();

    /**
     * 获取选中的交易
     * @param id
     * @return
     */
    List<Tran> getCheckAllTran(String[] id);

    /**
     * 导入交易
     * @param dataList
     * @return
     */
    boolean doImport(List<Tran> dataList);

    /**
     * 获取交易历史列表
     * @param tranId
     * @return
     */
    List<TranHistory> getHistoryList(String tranId);

    /**
     * 更新阶段
     * @param tran
     * @return
     */
    boolean updateStage(Tran tran);

    /**
     * 获取交易备注
     * @param tranId
     * @return
     */
    List<TranRemark> getRemarkList(String tranId);

    /**
     * 保存交易备注
     * @param tranRemark
     * @return
     */
    Map<String,Object> saveRemark(TranRemark tranRemark);

    /**
     * 更新交易备注
     * @param tranRemark
     * @return
     */
    Map<String, Object> updateRemark(TranRemark tranRemark);

    /**
     * 删除交易备注
     * @param id
     * @return
     */
    boolean deleteRemark(String id);
}
