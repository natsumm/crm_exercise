package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.Customer;
import com.bjming.crm.workbench.mapper.CustomerMapper;
import com.bjming.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 2020/12/13 by AshenOne
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<Customer> queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }

    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int queryCountOfCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerByCondition(map);
    }

    @Override
    public int deleteCustomerByIds(String[] ids) {
        return customerMapper.deleteCustomerByIds(ids);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int saveEditCustomer(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }
}


