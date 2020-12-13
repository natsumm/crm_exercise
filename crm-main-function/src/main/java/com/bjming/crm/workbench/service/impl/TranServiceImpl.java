package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.Tran;
import com.bjming.crm.workbench.mapper.TranMapper;
import com.bjming.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/13 by AshenOne
 */
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranMapper tranMapper;

    @Override
    public List<Tran> queryTranForDetailByCustomerId(String customerId) {
        return tranMapper.selectTranForDetailByCustomerId(customerId);
    }
}


