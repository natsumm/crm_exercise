package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * 2020/12/12 by AshenOne
 */
public interface ContactsService {
    List<Contacts> queryContactsByFullName(String fullname);

    List<Contacts> queryContactsForDetailByCustomerId(String customerId);
}
