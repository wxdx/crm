package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.workbench.dao.ActivityDao;
import com.wkcto.crm.workbench.domain.Activity;
import com.wkcto.crm.workbench.domain.ActivityRemark;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.workbench.service.ActivityService;
import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.vo.PaginationVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ActivityDao.class);
    @Override
    public List<User> getOwner() {
        return activityDao.getIdAndName();
    }

    @Override
    public int save(Activity activity) {
        return activityDao.save(activity);
    }


    @Override
    public Map<String, String> getEditInfo(String id) {
        return activityDao.getInfoById(id);
    }

    @Override
    public int doUpdate(Activity activity) {
        return activityDao.update(activity);

    }

    @Override
    public int doDelete(String[] id) {
        return activityDao.delete(id);
    }

    @Override
    public PaginationVO<Activity> page(Map<String, Object> map) {
        PaginationVO<Activity> page1 = new PaginationVO<>();
        page1.setTotal(activityDao.getTotal(map));
        page1.setaList(activityDao.getPageList(map));
        return page1;
    }

    @Override
    public List<ActivityRemark> getRemarkList(String activityId) {
        return activityDao.getRemark(activityId);
    }

    @Override
    public Map<String,Object> doRemarkSave(ActivityRemark activityRemark) {
        Map<String,Object> map = new HashMap<>();
        map.put("activityRemark",activityRemark);
        map.put("success",activityDao.doRemarkSave(activityRemark) == 1);
        return map;
    }

    @Override
    public int deleteRemark(String id) {
        return activityDao.deleteRemark(id);
    }

    @Override
    public Map<String,Object> updateRemark(ActivityRemark activityRemark) {
        Map<String,Object> map = new HashMap<>();
        if (activityDao.updateRemark(activityRemark) == 1){
            map.put("success",activityDao.updateRemark(activityRemark) == 1);
            map.put("noteContent",activityRemark.getNoteContent());
            map.put("editBy",activityRemark.getEditBy());
            map.put("editTime",activityRemark.getEditTime());
        }
        return map;
    }

    @Override
    public List<Activity> getAllActivity() {
        return activityDao.getActivityList();
    }

    @Override
    public List<Activity> getAllCheckActivity(String[] id) {
        return activityDao.getCheckAllActivity(id);
    }

    @Override
    public boolean doImport(List<Activity> dataList) {
        return activityDao.doImport(dataList) >= 1;
    }

    @Override
    public List<Activity> doGetNeverRelationActivity(String clueId,String name) {
        return activityDao.doGetNeverRelationActivity(clueId,name);
    }

    @Override
    public List<Activity> getAll(String name) {
        return activityDao.getAll(name);
    }

    @Override
    public List<Activity> doGetNeverRelationActivity1(String contactId, String name) {
        return activityDao.doGetNeverRelationActivity1(contactId,name);
    }
}
