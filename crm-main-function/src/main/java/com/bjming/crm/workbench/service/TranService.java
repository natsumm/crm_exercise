package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.Tran;

import java.util.List;

/**
 * 2020/12/13 by AshenOne
 */
public interface TranService {
    List<Tran> queryTranForDetailByCustomerId(String customerId);

    int deleteTranById(String id);
}


