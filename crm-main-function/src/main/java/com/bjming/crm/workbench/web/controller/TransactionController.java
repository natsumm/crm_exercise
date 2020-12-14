package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.settings.service.DicValueService;
import com.bjming.crm.settings.service.UserService;
import com.bjming.crm.workbench.domain.Tran;
import com.bjming.crm.workbench.service.ActivityService;
import com.bjming.crm.workbench.service.ContactsService;
import com.bjming.crm.workbench.service.CustomerService;
import com.bjming.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

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
    @Autowired
    private TranService tranService;
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

    @RequestMapping("/workbench/transaction/queryCustomerNameByName.do")
    @ResponseBody
    public Object queryCustomerNameByName(String customerName) {
        return customerService.queryCustomerNameByName(customerName);
    }

    @RequestMapping("/workbench/transaction/queryPossibilityByStageValue.do")
    @ResponseBody
    public Object queryPossibilityByStageValue(String stageValue) {
        /**
         * 使用Properties获取properties文件中的属性时需要使用io流, 而io流的使用需要使用绝对路径,
         * windows下的绝对路径从盘符开始, 将来应用部署到Linux服务器上时, 需要修改路径,
         * 可选的解决办法是使用另一个配置文件或者java常量来声明配置文件的路径, 将来部署服务时直接修改配置文件
         * 但是这种方法现在已经是有些过时的技术;
         *
         *      现在可以直接使用ResourceBundle类, 由jdk提供, 可以使用相对路径, 不需要文件的扩展名, 可以直接使用,
         *      相对路径默认从编译后的classpath, classes根目录下开始, 所以linux照样试用;
         *      ResourceBundle.getBundle("classpath编译后class根路径开始的相对目录, 不需要文件的扩展名, 不需要classpath关键字");
         */
        //new Properties().load(new FileInputStream(""));

        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        return bundle.getString(stageValue);
    }

    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(Tran tran, String customerName, HttpSession session) {
        ReturnObject returnObject = null;
        Map<String, Object> map = new HashMap<>();
        //封装参数
        map.put("tran", tran);
        map.put(MyConstants.SESSION_USER, session.getAttribute(MyConstants.SESSION_USER));
        map.put("customerName", customerName);
        try { //调用service处理请求, 不抛出异常就视为成功
            tranService.saveCreateTran(map);
            returnObject = ReturnObject.getSuccessReturnObject();
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }
}


