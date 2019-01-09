package com.wkcto.crm.workbench.service.impl;

import com.wkcto.crm.workbench.domain.TranHistory;
import com.wkcto.crm.utils.DateUtil;
import com.wkcto.crm.utils.SqlSeesionUtil;
import com.wkcto.crm.utils.UUIDGenerator;
import com.wkcto.crm.vo.PaginationVO;
import com.wkcto.crm.workbench.dao.*;
import com.wkcto.crm.workbench.domain.*;
import com.wkcto.crm.workbench.service.ClueService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 线索service实现层
 */
public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ClueDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ClueActivityRelationDao.class);
    private CustomerDao customerDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(CustomerDao.class);
    private ContactDao contactDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ContactDao.class);
    private ContactActivityRelationDao contactActivityRelationDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ContactActivityRelationDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ClueRemarkDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(CustomerRemarkDao.class);
    private ContactRemarkDao contactRemarkDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(ContactRemarkDao.class);
    private TranDao tranDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(TranDao.class);
    private TranRemarkDao tranRemarkDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(TranRemarkDao.class);
    private TranHistoryDao tranHistoryDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(TranHistoryDao.class);

    @Override
    public boolean doSave(Clue clue) {
        return clueDao.doSave(clue) == 1;
    }

    @Override
    public PaginationVO<Clue> page(Map<String, Object> map) {
        PaginationVO<Clue> page1 = new PaginationVO<>();
        page1.setTotal(clueDao.getTotal(map));
        page1.setaList(clueDao.getPageList(map));
        return page1;
    }

    @Override
    public Map<String, Object> getDetail(String id) {
        return clueDao.getById(id);
    }

    @Override
    public boolean doUpdate(Clue clue) {
        return clueDao.update(clue) == 1;
    }

    @Override
    public boolean doDelete(String[] id) {

        boolean flag = false;
        if ((clueDao.delete(id)) >= 1 && (clueRemarkDao.delByClueIdArray(id)) >= 0) {
            flag = true;
        }
        return flag;
    }

    @Override
    public List<Clue> getAllClue() {
        return clueDao.getAllClue();
    }

    @Override
    public List<Clue> getCheckAllClue(String[] id) {
        return clueDao.getCheckClue(id);
    }

    @Override
    public boolean doImport(List<Clue> dataList) {
        return (clueDao.doImport(dataList)) >= 1;
    }

    @Override
    public List<ClueRemark> getRemarkList(String clueId) {
        return clueDao.getRemarkList(clueId);
    }

    @Override
    public Map<String, Object> doRemarkSave(ClueRemark clueRemark) {
        Map<String, Object> map = new HashMap<>();
        map.put("clueRemark", clueRemark);
        map.put("success", clueDao.doRemarkSave(clueRemark) == 1);
        return map;
    }

    @Override
    public Map<String, Object> updateRemark(ClueRemark clueRemark) {
        Map<String, Object> map = new HashMap<>();
        if (clueDao.updateRemark(clueRemark) == 1) {
            map.put("success", clueDao.updateRemark(clueRemark) == 1);
            map.put("noteContent", clueRemark.getNoteContent());
            map.put("editBy", clueRemark.getEditBy());
            map.put("editTime", clueRemark.getEditTime());
        }
        return map;
    }

    @Override
    public int deleteRemark(String id) {
        return clueDao.deleteRemark(id);
    }

    @Override
    public void convert(String clueId, String operator, Tran tran) {
//        1.根据线索id获取线索信息
        Clue clue = clueDao.getById2(clueId);
//        2.将线索信息中的客户信息提取出来,放到客户表中(客户不可重复,按照公司的名称判断客户是否已存在,精确匹配)
        Customer customer = customerDao.getByName(clue.getCompany());
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDGenerator.generate());
            customer.setOwner(clue.getOwner());
            customer.setName(clue.getCompany());
            customer.setPhone(clue.getPhone());
            customer.setWebsite(clue.getWebsite());
            customer.setDescription(clue.getDescription());
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setAddress(clue.getAddress());
            customer.setCreateBy(operator);
            customer.setCreateTime(DateUtil.getSysTime());
            customerDao.save(customer);
        }
//        3.将线索信息中的联系人信息提取出来,放到联系人表当中
        Contact contact = new Contact();
        contact.setId(UUIDGenerator.generate());
        contact.setOwner(clue.getOwner());
        contact.setSource(clue.getSource());
        contact.setAppellation(clue.getAppellation());
        contact.setName(clue.getFullname());
        contact.setJob(clue.getJob());
        contact.setMphone(clue.getMphone());
        contact.setEmail(clue.getEmail());
        contact.setCustomerId(customer.getId());
        contact.setDescription(clue.getDescription());
        contact.setContactSummary(clue.getContactSummary());
        contact.setNextContactTime(clue.getNextContactTime());
        contact.setAddress(clue.getAddress());
        contact.setCreateBy(operator);
        contact.setCreateTime(DateUtil.getSysTime());
        contactDao.save(contact);
//        4.将"线索和市场活动的关系"转换到"联系人和市场活动的关系"当中
        List<String> alist = clueActivityRelationDao.getActivityIdByClueId(clueId);
        if (alist.size() > 0) {
            List<ContactActivityRelation> carList = new ArrayList<>();
            for (String activityId : alist) {
                ContactActivityRelation car = new ContactActivityRelation();
                car.setId(UUIDGenerator.generate());
                car.setActivityId(activityId);
                car.setContactId(contact.getId());
                carList.add(car);
            }
            contactActivityRelationDao.save(carList);
        }
//        5.线索备注转换到:联系人备注.客户备注当中
        List<ClueRemark> crList = clueRemarkDao.getClueRemarkByClueId(clueId);
        if (crList.size() > 0) {
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactRemark> contactRemarkList = new ArrayList<>();
            for (ClueRemark c : crList) {
                CustomerRemark cr1 = new CustomerRemark();
                ContactRemark cr2 = new ContactRemark();
                cr1.setId(UUIDGenerator.generate());
                cr2.setId(UUIDGenerator.generate());
                cr1.setNoteContent(c.getNoteContent());
                cr2.setNoteContent(c.getNoteContent());
                cr1.setCreateBy(c.getCreateBy());
                cr2.setCreateBy(c.getCreateBy());
                cr1.setCreateTime(c.getCreateTime());
                cr2.setCreateTime(c.getCreateTime());
                cr1.setEditBy(c.getEditBy());
                cr2.setEditBy(c.getEditBy());
                cr1.setEditTime(c.getEditTime());
                cr2.setEditTime(c.getEditTime());
                cr1.setCustomerId(customer.getId());
                cr2.setContactId(contact.getId());
                cr1.setEditFlag(c.getEditFlag());
                cr2.setEditFlag(c.getEditFlag());
                customerRemarkList.add(cr1);
                contactRemarkList.add(cr2);
            }
            customerRemarkDao.save(customerRemarkList);
            contactRemarkDao.save(contactRemarkList);
        }
//        6.判断用户是否在线索转换的同时创建交易,假设用户选择了创建交易 则:
//                 将交易信息保存到交易表

        if (tran != null) {
            tran.setOwner(clue.getOwner());
            tran.setCustomerId(customer.getId());
            tran.setSource(clue.getSource());
            tran.setContactsId(contact.getId());
            tran.setCreateBy(operator);
            tranDao.save(tran);

            TranHistory th = new TranHistory();
            th.setId(UUIDGenerator.generate());
            th.setStage(clue.getState());
            th.setMoney(tran.getMoney());
            th.setExpectedDate(tran.getExpectedDate());
            th.setCreateTime(tran.getCreateTime());
            th.setCreateBy(tran.getCreateBy());
            th.setTranId(tran.getId());
            tranHistoryDao.save(th);
//                 将线索备注转换到交易备注
            if (crList.size() > 0) {
                List<TranRemark> tranRemarkList = new ArrayList<>();
                for (ClueRemark c : crList) {
                    TranRemark t = new TranRemark();
                    t.setId(UUIDGenerator.generate());
                    t.setNoteContent(c.getNoteContent());
                    t.setCreateBy(c.getCreateBy());
                    t.setCreateTime(c.getCreateTime());
                    t.setEditBy(c.getEditBy());
                    t.setEditTime(c.getEditTime());
                    t.setEditFlag(c.getEditFlag());
                    t.setTranId(tran.getId());

                    tranRemarkList.add(t);
                }
                tranRemarkDao.save(tranRemarkList);
            }

        }
//        7.删除线索备注
        clueRemarkDao.delByClueId(clueId);
//        8.删除线索和市场活动的关系
        clueActivityRelationDao.delByClueId(clueId);
//        9.删除线索
        clueDao.delById(clueId);
    }
}
