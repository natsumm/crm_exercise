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
import org.springframework.util.ObjectUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
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
        String isCreateTran = (String) map.get("isCreateTran");
        Tran tran = (Tran) map.get("tran");
        String clueId = (String) map.get("clueId");
        //1,根据id查询线索
        Clue clue = clueMapper.selectClueById(clueId);

        //2,生成customer对象
        Customer customer = new Customer();
        ClueConvertUtils.injectAttributeValue(clue, customer);
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateFormatUtils.getSysDateTime());

        //3,添加customer记录
        customerMapper.insertCustomer(customer);

        //4,生成contacts对象
        Contacts contacts = new Contacts();
        ClueConvertUtils.injectAttributeValue(clue, contacts);
        contacts.setOwner(user.getId());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateFormatUtils.getSysDateTime());
        contacts.setCustomerId(customer.getId());
        //5,添加contacts记录
        contactsMapper.insertContacts(contacts);

        //6,根据线索id, 查询多条线索备注
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkForConvertByClueId(clueId);
        if (clueRemarkList != null && clueRemarkList.size() > 0) {
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            CustomerRemark customerRemark = null;
            ContactsRemark contactsRemark = null;

            for (ClueRemark cr : clueRemarkList) {
                //生成customerRemark对象, 放入集合中
                customerRemark = new CustomerRemark();
                ClueConvertUtils.injectAttributeValue(cr, customerRemark);
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);

                //生成contactsRemark对象, 放入集合中
                contactsRemark = new ContactsRemark();
                ClueConvertUtils.injectAttributeValue(cr, contactsRemark);
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkList.add(contactsRemark);
            }
            //7,从集合中插入多条客户备注记录
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);
            //8,从集合中插入多条联系人备注
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }


        //9,根据线索id查询多条线索-市场活动关联关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
        if (!ObjectUtils.isEmpty(clueActivityRelationList)) {
            ContactsActivityRelation contactsActivityRelation = null;
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            for (ClueActivityRelation car : clueActivityRelationList) {
                //生成联系人和市场活动关联记录
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setActivityId(car.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            //10,从实体类集合中插入联系人和市场活动的关联记录
            contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelationList);
        }

        //10,如果需要创建交易, 就向交易表中添加一条记录
        if ("true".equals(isCreateTran)) {
            //这里的交易不是由线索转换过来的, 而是由用户创建的所以有些字段是空的, 不能从线索中直接赋值, 直接赋空值;
            //ClueConvertUtils.injectAttributeValue(clue, tran);
            tran.setId(user.getId());
            tran.setOwner(user.getId());
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateFormatUtils.getSysDateTime());
            tran.setCustomerId(customer.getId());
            tranMapper.insertTran(tran);


            //11,添加交易的备注记录
            if (clueRemarkList != null && clueRemarkList.size() > 0) {
                TranRemark tranRemark = null;
                List<TranRemark> tranRemarkList = new ArrayList<>();
                for (ClueRemark cr : clueRemarkList) {
                    tranRemark = new TranRemark();
                    ClueConvertUtils.injectAttributeValue(cr, tranRemark);
                    tranRemark.setTranId(tran.getId());
                    tranRemarkList.add(tranRemark);
                }
                tranRemarkMapper.insertTranRemarkByList(tranRemarkList);
            }
        }

        //11,删除线索备注
        if (clueRemarkList != null && clueRemarkList.size() > 0) {
            clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        }

        //12,删除线索和市场活动的关联关系
        if (clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
            clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        }

        //13,删除线索
        clueMapper.deleteClueById(clueId);
    }
}


