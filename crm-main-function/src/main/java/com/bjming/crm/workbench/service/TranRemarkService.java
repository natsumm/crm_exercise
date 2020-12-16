package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.TranRemark;

import java.util.List;

/**
 * 2020/12/16 by AshenOne
 */
public interface TranRemarkService {
    List<TranRemark> queryTranRemarkForDetailByTranId(String tranId);
}
