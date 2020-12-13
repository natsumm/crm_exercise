package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.settings.service.DicValueService;
import com.bjming.crm.settings.service.UserService;
import com.bjming.crm.workbench.service.ActivityService;
import com.bjming.crm.workbench.service.ContactsService;
import com.bjming.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * 2020/12/12 by AshenOne
 */
@Controller
public class TransactionController {
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;

    @RequestMapping("/workbench/transaction/toIndex.do")
    public ModelAndView toIndex() {
        ModelAndView mv = new ModelAndView();
        mv.addObject("stageList", dicValueService.queryDicValuesByTypeCode("stage"));
        mv.addObject("typeList", dicValueService.queryDicValuesByTypeCode("transactionType"));
        mv.addObject("sourceList", dicValueService.queryDicValuesByTypeCode("source"));
        mv.setViewName("workbench/transaction/index");
        return mv;
    }

    @RequestMapping("/workbench/transaction/toSave.do")
    public ModelAndView toSave() {
        ModelAndView mv = new ModelAndView();
        mv.addObject("userList", userService.queryAllAvailableUsers());
        mv.addObject("stageList", dicValueService.queryDicValuesByTypeCode("stage"));
        mv.addObject("typeList", dicValueService.queryDicValuesByTypeCode("transactionType"));
        mv.addObject("sourceList", dicValueService.queryDicValuesByTypeCode("source"));
        mv.setViewName("workbench/transaction/save");
        return mv;
    }

    @RequestMapping("/workbench/transaction/queryActivityByName.do")
    @ResponseBody
    public Object queryActivityByName(String activityName) {
        return activityService.queryActivityByName(activityName);
    }

    @RequestMapping("/workbench/transaction/queryContactsByFullname.do")
    @ResponseBody
    public Object queryContactsByFullname(String contactsName) {
        return contactsService.queryContactsByFullName(contactsName);
    }

    @RequestMapping("/workbench/transaction/queryCustomerByName.do")
    @ResponseBody
    public Object queryCustomerByName(String customerName) {
        return customerService.queryCustomerByName(customerName);
    }

}


