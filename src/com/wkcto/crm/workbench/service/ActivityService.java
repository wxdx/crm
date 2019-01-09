package com.wkcto.crm.workbench.service;

import com.wkcto.crm.workbench.domain.Activity;
import com.wkcto.crm.workbench.domain.ActivityRemark;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
     * 根据id查询user表中的name
     * @return
     */
    List<User> getOwner();

    /**
     * 市场活动保存
     * @param activity
     * @return
     */
    int save(Activity activity);

    /**
     * 获取更新初始值
     * @param id
     * @return
     */
    Map<String, String> getEditInfo(String id);

    /**
     * 市场活动更新
     * @param activity
     * @return
     */
    int doUpdate(Activity activity);

    /**
     * 市场活动删除
     * @param id
     * @return
     */
    int doDelete(String[] id);

    /**
     * 分页查询
     * @param map
     * @return
     */
    PaginationVO<Activity> page(Map<String, Object> map);

    /**
     * 获取备注列表
     * @param activityId
     * @return
     */
    List<ActivityRemark> getRemarkList(String activityId);

    /**
     * 保存备注
     * @param activityRemark
     * @return
     */
    Map<String,Object> doRemarkSave(ActivityRemark activityRemark);

    /**
     * 删除备注
     * @param id
     * @return
     */
    int deleteRemark(String id);

    /**
     * 更新备注
     * @param activityRemark
     * @return
     */
    Map<String,Object> updateRemark(ActivityRemark activityRemark);

    /**
     * 导出所有市场活动列表信息
     * @return
     */
    List<Activity> getAllActivity();

    /**
     * 导出选中的市场活动信息
     * @param id
     * @return
     */
    List<Activity> getAllCheckActivity(String[] id);

    /**
     * 导入市场信息
     * @param dataList
     * @return
     */
    boolean doImport(List<Activity> dataList);

    /**
     * clue中获取没有关联过的市场活动
     * @param clueId
     * @param name
     * @return
     */
    List<Activity> doGetNeverRelationActivity(String clueId,String name);

    /**
     * 通过name获取市场活动
     * @param name
     * @return
     */
    List<Activity> getAll(String name);

    /**
     * 通过contactId获取没有关联过的市场活动
     * @param contactId
     * @param name
     * @return
     */
    List<Activity> doGetNeverRelationActivity1(String contactId, String name);
}
