package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.TranRemark;
import com.bjming.crm.workbench.mapper.TranRemarkMapper;
import com.bjming.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/16 by AshenOne
 */
@Service
public class TranRemarkServiceImpl implements TranRemarkService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<TranRemark> queryTranRemarkForDetailByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkForDetailByTranId(tranId);
    }
}


