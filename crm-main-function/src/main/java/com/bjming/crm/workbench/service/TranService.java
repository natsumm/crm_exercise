package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * 2020/12/13 by AshenOne
 */
public interface TranService {
    List<Tran> queryTranForDetailByCustomerId(String customerId);

    int deleteTranById(String id);

    void saveCreateTran(Map<String, Object> map);

    List<Tran> queryTranByConditionForPage(Map<String, Object> map);

    int queryCountOfTranByCondition(Map<String, Object> map);

    List<Map> queryCountOfTranGroupByStage();

    Tran queryTranForDetailById(String id);
}


