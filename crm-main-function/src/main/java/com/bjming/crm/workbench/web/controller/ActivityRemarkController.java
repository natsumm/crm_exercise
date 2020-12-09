package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.workbench.domain.ActivityRemark;
import com.bjming.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 2020/12/09 by AshenOne
 */
@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark remark, HttpSession session) {
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        ReturnObject returnObject = null;
        //封装前端未上传参数
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateBy(user.getId());
        remark.setCreateTime(DateFormatUtils.getSysDateTime());
        remark.setEditFlag(MyConstants.REMARK_EDIT_FLAG_NOT_MODIFIED);
        //插入数据
        try {
            int rows = activityRemarkService.saveCreateActivityRemark(remark);
            //添加成功, 将remark对象放入响应信息中
            returnObject = ReturnObject.getReturnObjectByRows(rows, remark);
        } catch (Exception e) {
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    @ResponseBody
    public Object deleteActivityRemarkById(String remarkId) {
        ReturnObject returnObject = null;
        try {
            int rows = activityRemarkService.deleteActivityRemarkById(remarkId);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    @ResponseBody
    public Object saveEditActivityRemark(ActivityRemark remark, HttpSession session) {
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        ReturnObject returnObject = null;
        //封装前端未上传参数
        remark.setEditBy(user.getId());
        remark.setEditFlag(MyConstants.REMARK_EDIT_FLAG_MODIFIED);
        remark.setEditTime(DateFormatUtils.getSysDateTime());
        try {
            int rows = activityRemarkService.saveEditActivityRemark(remark);
            //更新成功, 将封装好的activityRemark对象放入retData中, 便于前端局部刷新
            returnObject = ReturnObject.getReturnObjectByRows(rows, remark);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }

        return returnObject;
    }
}


