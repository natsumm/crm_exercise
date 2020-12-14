package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.CustomerRemark;

import java.util.List;

/**
 * 2020/12/13 by AshenOne
 */
public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId);

    int saveCreateCustomerRemark(CustomerRemark remark);

    int deleteCustomerRemarkById(String id);

    int saveEditCustomerRemark(CustomerRemark remark);
}


