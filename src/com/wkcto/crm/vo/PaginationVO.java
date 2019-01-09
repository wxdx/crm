package com.wkcto.crm.vo;

import java.util.List;

/**
 * VO视图JavaBean
 * @param <T>
 */
public class PaginationVO<T> {
    private Long total;
    private List<T> aList;

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public List<T> getaList() {
        return aList;
    }

    public void setaList(List<T> aList) {
        this.aList = aList;
    }
}
