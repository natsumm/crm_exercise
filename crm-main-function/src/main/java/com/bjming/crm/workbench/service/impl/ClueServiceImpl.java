package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.utils.ClueConvertUtils;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.workbench.domain.*;
import com.bjming.crm.workbench.mapper.*;
import com.bjming.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 2020/12/09 by AshenOne
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);

    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) throws Exception {
        User user = (User) map.get(MyConstants.SESSION_USER);
        String clueId = (String) map.get("clueId");
        //1,根据id查询线索
        Clue clue = clueMapper.selectClueById(clueId);
        //2,生成customer对象
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateFormatUtils.getSysDateTime());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        //3,添加customer记录
        customerMapper.insertCustomer(customer);

        //4,生成contacts对象
        Contacts contacts = (Contacts) ClueConvertUtils.injectAttributeValue(clue, Contacts.class, "customer");
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateFormatUtils.getSysDateTime());
        contacts.setCustomerId(customer.getId());
        //5,添加contacts记录
        contactsMapper.insertContacts(contacts);

        //6,根据线索id, 查询多条线索备注
        CustomerRemark customerRemark = null;
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkForConvertByClueId(clueId);
        List<CustomerRemark> customerRemarkList=new ArrayList<>();
        if (clueRemarkList != null && clueRemarkList.size() > 0) {
            for (ClueRemark cr : clueRemarkList) {
                customerRemark = (CustomerRemark) ClueConvertUtils.injectAttributeValue(cr, CustomerRemark.class, "customerRemark");
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);
            }
        }
        //7,从集合中插入多条客户备注记录
        customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);
    }
}


