package com.wkcto.crm.settings.service;

import com.wkcto.crm.settings.domain.Dept;

import java.util.List;
import java.util.Map;

public interface DeptService {
    int doSave(Dept dept);

    int doCheck(String deptno);

    List<Dept> doGetList();

    Dept doGetOne(String deptno);

    int doUpdate(Map<String, String> map);

    int doDelete(String[] deptno);

    List<Dept>  getListForUser();
}
