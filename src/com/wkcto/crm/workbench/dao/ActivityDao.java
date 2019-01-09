package com.wkcto.crm.workbench.dao;

import com.wkcto.crm.workbench.domain.Activity;
import com.wkcto.crm.workbench.domain.ActivityRemark;
import com.wkcto.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * ActivityDao层
 */
public interface ActivityDao {
    List<User> getIdAndName();

    int save(Activity activity);

    Map<String, String> getInfoById(String id);

    int update(Activity activity);

    int delete(String[] id);

    List<Activity> getPageList(Map<String, Object> map);

    Long getTotal(Map<String, Object> map);

    List<ActivityRemark> getRemark(String activityId);

    int doRemarkSave(ActivityRemark activityRemark);

    int deleteRemark(String id);

    int updateRemark(ActivityRemark activityRemark);

    List<Activity> getActivityList();

    List<Activity> getCheckAllActivity(String[] id);

    int doImport(List<Activity> dataList);

    List<Activity> doGetNeverRelationActivity(String clueId, String name);

    List<Activity> getAll(String name);

    List<Activity> doGetNeverRelationActivity1(String contactId, String name);
}
