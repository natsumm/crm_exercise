package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.Contacts;
import com.bjming.crm.workbench.mapper.ContactsMapper;
import com.bjming.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/12 by AshenOne
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsByFullName(String fullname) {
        return contactsMapper.selectContactsByFullname(fullname);
    }

    @Override
    public List<Contacts> queryContactsForDetailByCustomerId(String customerId) {
        return contactsMapper.selectContactsForDetailByCustomerId(customerId);
    }
}


