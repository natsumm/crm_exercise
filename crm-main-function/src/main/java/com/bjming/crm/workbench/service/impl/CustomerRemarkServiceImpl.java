package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.CustomerRemark;
import com.bjming.crm.workbench.mapper.CustomerRemarkMapper;
import com.bjming.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/13 by AshenOne
 */
@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkForDetailByCustomerId(customerId);
    }
}


