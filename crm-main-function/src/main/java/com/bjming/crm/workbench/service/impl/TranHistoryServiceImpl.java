package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.TranHistory;
import com.bjming.crm.workbench.mapper.TranHistoryMapper;
import com.bjming.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/16 by AshenOne
 */
@Service
public class TranHistoryServiceImpl implements TranHistoryService {
    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    @Override
    public List<TranHistory> queryTranHistoryForDetailByTranId(String tranId) {
        return tranHistoryMapper.selectTranHistoryForDetailByTranId(tranId);
    }
}


