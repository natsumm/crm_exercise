package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.workbench.domain.Customer;
import com.bjming.crm.workbench.domain.Tran;
import com.bjming.crm.workbench.mapper.CustomerMapper;
import com.bjming.crm.workbench.mapper.TranMapper;
import com.bjming.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * 2020/12/13 by AshenOne
 */
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<Tran> queryTranForDetailByCustomerId(String customerId) {
        ResourceBundle bundle = ResourceBundle.getBundle("possibility"); //不需要扩展名
        List<Tran> tranList = tranMapper.selectTranForDetailByCustomerId(customerId);
        //tran的阶段采用连接查询, 查询value, 这里再根据呀value从配置文件中读取可能性
        if (tranList != null && tranList.size() > 0) {
            for (Tran tran : tranList) {
                String stageValue = tran.getStage();
                tran.setPossibility(bundle.getString(stageValue));
            }
        }
        return tranList;
    }

    @Override
    public int deleteTranById(String id) {
        return tranMapper.deleteTranById(id);
    }

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        User user = (User) map.get(MyConstants.SESSION_USER);
        String customerName = (String) map.get("customerName");
        Tran tran = (Tran) map.get("tran");

        //根据名称精确查询客户
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer();
            //不存在对应记录, 则创建对应记录
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId()); //创建的客户拥有者默认为当前用户;
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateFormatUtils.getSysDateTime());
            customerMapper.insertCustomer(customer);
        }

        tran.setCustomerId(customer.getId());
        tran.setId(UUIDUtils.getUUID());
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateFormatUtils.getSysDateTime());
        tranMapper.insertTran(tran);
    }

    @Override
    public List<Tran> queryTranByConditionForPage(Map<String, Object> map) {
        return tranMapper.selectTranByConditionForPage(map);
    }

    @Override
    public int queryCountOfTranByCondition(Map<String, Object> map) {
        return tranMapper.selectCountOfTranByCondition(map);
    }

    @Override
    public List<Map> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }
}


