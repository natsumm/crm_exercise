package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * 2020/12/13 by AshenOne
 */
public interface CustomerService {
    List<Customer> queryCustomerByName(String name);

    int saveCreateCustomer(Customer customer);

    List<Customer> queryCustomerByConditionForPage(Map<String, Object> map);

    int queryCountOfCustomerByCondition(Map<String, Object> map);

    int deleteCustomerByIds(String[] ids);

    Customer queryCustomerById(String id);

    int saveEditCustomer(Customer customer);
}
