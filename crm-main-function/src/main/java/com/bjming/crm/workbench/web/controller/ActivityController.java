package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.settings.service.UserService;
import com.bjming.crm.workbench.domain.Activity;
import com.bjming.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * /WEB-INF/pages/workbench/activity/
 * 2020/12/07 by AshenOne
 */
@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/toIndex.do")
    public String toIndex(Model model){
        model.addAttribute("userList", userService.queryAllAvailableUsers());
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session){
        User user= (User) session.getAttribute(MyConstants.SESSION_USER);
        ReturnObject returnObject=null;
        //封装前端未上传参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateBy(user.getId());
        activity.setCreateTime(DateFormatUtils.getSysDateTime());
        try {
            int rows = activityService.saveCreateActivity(activity);
            returnObject=ReturnObject.getReturnObjectByRows(rows);
        }catch(Exception e){
            e.printStackTrace();
            returnObject= ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(@RequestParam Map<String,Object> map){
        List<Activity> activityList=activityService.queryActivityByConditionForPage(map);
        int totalRows=activityService.queryCountOfActivityByCondition(map);
        map.clear();
        map.put("activityList", activityList);
        map.put("totalRows",totalRows);
        return map;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        ReturnObject returnObject=null;
        try {
            int rows = activityService.deleteActivityByIds(id);
            returnObject=ReturnObject.getReturnObjectByRows(rows, rows); //删除成功, 将删除的记录数目返回;
        }catch(Exception e){
            e.printStackTrace();
            returnObject=ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }
}


