package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.CustomerRemark;

import java.util.List;

/**
 * 2020/12/13 by AshenOne
 */
public interface CustomerRemarkService {
    List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId);
}


