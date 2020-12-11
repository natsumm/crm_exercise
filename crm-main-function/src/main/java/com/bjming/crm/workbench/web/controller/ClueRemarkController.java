package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.workbench.domain.ClueRemark;
import com.bjming.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 2020/12/11 by AshenOne
 */
@Controller
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark remark, HttpSession session) {
        ReturnObject returnObject = null;
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        //封装前端未上传参数
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateBy(user.getId());
        remark.setCreateTime(DateFormatUtils.getSysDateTime());
        remark.setEditFlag(MyConstants.REMARK_EDIT_FLAG_NOT_MODIFIED);
        try {
            int rows = clueRemarkService.saveCreateClueRemark(remark);
            //插入成功, 将封装好的实体类对象返回, 方便前端进行局部刷新;
            returnObject = ReturnObject.getReturnObjectByRows(rows, remark);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    @ResponseBody
    public Object deleteClueRemarkById(String remarkId) {
        ReturnObject returnObject = null;
        try {
            int rows = clueRemarkService.deleteClueRemarkById(remarkId);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveEditClueRemark.do")
    @ResponseBody
    public Object saveEditClueRemark(ClueRemark remark, HttpSession session) {
        ReturnObject returnObject = null;
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        //封装前端未上传参数
        remark.setEditFlag(MyConstants.REMARK_EDIT_FLAG_MODIFIED);
        remark.setEditBy(user.getId());
        remark.setEditTime(DateFormatUtils.getSysDateTime());
        try {
            int rows = clueRemarkService.saveEditClueRemark(remark);
            //更新成功, 将封装好的remark对象返回, 方便前端进行局部刷新
            returnObject = ReturnObject.getReturnObjectByRows(rows, remark);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }
}


