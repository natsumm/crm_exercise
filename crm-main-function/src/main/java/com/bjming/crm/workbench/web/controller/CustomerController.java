package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.settings.service.UserService;
import com.bjming.crm.workbench.domain.Customer;
import com.bjming.crm.workbench.service.CustomerService;
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
}


