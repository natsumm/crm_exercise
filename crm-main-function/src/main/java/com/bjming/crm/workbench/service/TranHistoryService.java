package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.TranHistory;

import java.util.List;

/**
 * 2020/12/16 by AshenOne
 */
public interface TranHistoryService {
    List<TranHistory> queryTranHistoryForDetailByTranId(String tranId);
}


