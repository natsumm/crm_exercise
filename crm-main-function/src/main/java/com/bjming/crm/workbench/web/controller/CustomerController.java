package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.settings.service.DicValueService;
import com.bjming.crm.settings.service.UserService;
import com.bjming.crm.workbench.domain.Customer;
import com.bjming.crm.workbench.domain.CustomerRemark;
import com.bjming.crm.workbench.service.ContactsService;
import com.bjming.crm.workbench.service.CustomerRemarkService;
import com.bjming.crm.workbench.service.CustomerService;
import com.bjming.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * 2020/12/13 by AshenOne
 */
@Controller
public class CustomerController {
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TranService tranService;
    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/workbench/customer/toIndex.do")
    public ModelAndView toIndex() {
        ModelAndView mv = new ModelAndView();
        mv.addObject("userList", userService.queryAllAvailableUsers());
        mv.setViewName("workbench/customer/index");
        return mv;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    @ResponseBody
    public Object saveCreateCustomer(Customer customer, HttpSession session) {
        ReturnObject returnObject = null;
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        //封装前端未上传参数
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateTime(DateFormatUtils.getSysDateTime());
        customer.setCreateBy(user.getId());
        //调用service处理请求
        try {
            int rows = customerService.saveCreateCustomer(customer);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    /**
     * 根据条件分页查询客户, 查询符合条件的客户记录, 查询符合条件的客户记录数目
     *
     * @param map name, owner, phone, website, beginNo, pageSize
     */
    @RequestMapping("/workbench/customer/queryCustomerByConditionForPage.do")
    @ResponseBody
    public Object queryCustomerByConditionForPage(@RequestParam Map<String, Object> map) {
        List<Customer> customerList = customerService.queryCustomerByConditionForPage(map);
        int totalRows = customerService.queryCountOfCustomerByCondition(map);
        map.clear();
        map.put("customerList", customerList);
        map.put("totalRows", totalRows);
        return map;
    }

    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    @ResponseBody
    public Object deleteCustomerByIds(String[] id) {
        ReturnObject returnObject = null;
        try {
            int rows = customerService.deleteCustomerByIds(id);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String id) {
        return customerService.queryCustomerById(id);
    }

    @RequestMapping("/workbench/customer/saveEditCustomer.do")
    @ResponseBody
    public Object saveEditCustomer(Customer customer, HttpSession session) {
        ReturnObject returnObject = null;
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        //封装前端未上传参数
        customer.setEditBy(user.getId());
        customer.setEditTime(DateFormatUtils.getSysDateTime());
        try {
            int rows = customerService.saveEditCustomer(customer);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/toDetail.do")
    public ModelAndView toDetail(String customerId) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("customer", customerService.queryCustomerForDetailById(customerId));
        mv.addObject("customerRemarkList", customerRemarkService.queryCustomerRemarkForDetailByCustomerId(customerId));
        mv.addObject("tranList", tranService.queryTranForDetailByCustomerId(customerId));
        mv.addObject("contactsList", contactsService.queryContactsForDetailByCustomerId(customerId));
        //查询创建交易需要的下拉列表
        mv.addObject("userList", userService.queryAllAvailableUsers());
        mv.addObject("sourceList", dicValueService.queryDicValuesByTypeCode("source"));
        mv.addObject("appellationList", dicValueService.queryDicValuesByTypeCode("appellation"));
        mv.setViewName("workbench/customer/detail");
        return mv;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomerRemark.do")
    @ResponseBody
    public Object saveCreateCustomerRemark(CustomerRemark remark, HttpSession session) {
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        ReturnObject returnObject = null;
        //封装前端未上传参数
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateTime(DateFormatUtils.getSysDateTime());
        remark.setCreateBy(user.getId());
        remark.setEditFlag(MyConstants.REMARK_EDIT_FLAG_NOT_MODIFIED);
        try {
            int rows = customerRemarkService.saveCreateCustomerRemark(remark);
            //插入成功, 将封装好的remark对象返回, 便于前端进行局部刷新
            returnObject = ReturnObject.getReturnObjectByRows(rows, remark);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteCustomerRemarkById.do")
    @ResponseBody
    public Object deleteCustomerRemarkById(String remarkId) {
        ReturnObject returnObject = null;
        try {
            int rows = customerRemarkService.deleteCustomerRemarkById(remarkId);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/saveEditCustomerRemark.do")
    @ResponseBody
    public Object saveEditCustomerRemark(CustomerRemark remark, HttpSession session) {
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        ReturnObject returnObject = null;
        remark.setEditFlag(MyConstants.REMARK_EDIT_FLAG_MODIFIED);
        remark.setEditBy(user.getId());
        remark.setEditTime(DateFormatUtils.getSysDateTime());
        try {
            int rows = customerRemarkService.saveEditCustomerRemark(remark);
            //成功后将封装好的remark对象返回
            returnObject = ReturnObject.getReturnObjectByRows(rows, remark);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteTranById.do")
    @ResponseBody
    public Object deleteTranById(String tranId) {
        ReturnObject returnObject = null;
        try {
            int rows = tranService.deleteTranById(tranId);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteContactsById.do")
    @ResponseBody
    public Object deleteContactsById(String contactsId) {
        ReturnObject returnObject = null;
        try {
            int rows = contactsService.deleteContactsById(contactsId);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }
}


