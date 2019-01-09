package com.wkcto.crm.workbench.service;

import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.domain.Clue;
import com.wkcto.crm.workbench.domain.ClueRemark;
import com.wkcto.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    /**
     * 保存clue
     * @param clue
     * @return
     */
    boolean doSave(Clue clue);

    /**
     * 分页查询
     * @param map
     * @return
     */
    PaginationVO<Clue> page(Map<String, Object> map);

    /**
     * 通过id 获取详情页数据
     * @param id
     * @return
     */
    Map<String,Object> getDetail(String id);

    /**
     * 更新
     * @param clue
     * @return
     */

    boolean doUpdate(Clue clue);

    /**
     * 删除
     * @param id
     * @return
     */

    boolean doDelete(String[] id);

    /**
     * 获取所有线索
     * @return
     */

    List<Clue> getAllClue();

    /**
     * 获取选中的线索
     * @param id
     * @return
     */

    List<Clue> getCheckAllClue(String[] id);

    /**
     * 导入
     * @param dataList
     * @return
     */

    boolean doImport(List<Clue> dataList);

    /**
     * 获取线索备注列表
     * @param clueId
     * @return
     */

    List<ClueRemark> getRemarkList(String clueId);

    /**
     * 线索保存
     * @param clueRemark
     * @return
     */

    Map<String, Object> doRemarkSave(ClueRemark clueRemark);

    /**
     * 线索更改
     * @param clueRemark
     * @return
     */

    Map<String, Object> updateRemark(ClueRemark clueRemark);

    /**
     * 线索删除
     * @param id
     * @return
     */

    int deleteRemark(String id);

    /**
     * 线索转换
     * @param clueId
     */
    void convert(String clueId, String operator, Tran tran);
}
