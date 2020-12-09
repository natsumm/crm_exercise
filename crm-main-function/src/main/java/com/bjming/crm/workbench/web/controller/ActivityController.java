package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.HSSFUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.settings.service.UserService;
import com.bjming.crm.workbench.domain.Activity;
import com.bjming.crm.workbench.service.ActivityRemarkService;
import com.bjming.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
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

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/toIndex.do")
    public String toIndex(Model model) {
        model.addAttribute("userList", userService.queryAllAvailableUsers());
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session) {
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        ReturnObject returnObject = null;
        //封装前端未上传参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateBy(user.getId());
        activity.setCreateTime(DateFormatUtils.getSysDateTime());
        try {
            int rows = activityService.saveCreateActivity(activity);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(@RequestParam Map<String, Object> map) {
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);
        map.clear();
        map.put("activityList", activityList);
        map.put("totalRows", totalRows);
        return map;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id) {
        ReturnObject returnObject = null;
        try {
            int rows = activityService.deleteActivityByIds(id);
            returnObject = ReturnObject.getReturnObjectByRows(rows, rows); //删除成功, 将删除的记录数目返回;
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id) {
        return activityService.queryActivityById(id);
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object saveEditActivity(Activity activity, HttpSession session) {
        User currentUser = (User) session.getAttribute(MyConstants.SESSION_USER);
        ReturnObject returnObjet = null;
        //封装前端未上传参数
        activity.setEditTime(DateFormatUtils.getSysDateTime());
        activity.setEditBy(currentUser.getId());
        try {
            int rows = activityService.saveEditActivity(activity);
            returnObjet = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObjet = ReturnObject.getFailReturnObject();
        }
        return returnObjet;
    }

    @RequestMapping("/workbench/activity/exportAllActivity.do") //批量导出市场活动
    public void exportAllActivity(HttpServletResponse response) throws Exception {
        List<Activity> activityList = activityService.queryAllActivityForDetail();
        HSSFWorkbook wb = HSSFUtils.getExcelFromList(activityList);
        /*String fileName = "activity_" + DateFormatUtils.getDateTimeStamp(new Date()) + ".xls";
        //设置相应头, 浏览器接收到响应后会打开文件下载窗口, 而不是默认的行为->直接打开;
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
        //设置内容属性, 告知浏览器本次返回的响应信息是文件;
        response.setContentType("application/octet-stream;charset=utf-8");
        OutputStream out = response.getOutputStream();
        wb.write(out);

        //资源谁开启, 谁关闭;
        wb.close();
        out.flush();*/
        exportWorkbookHandler(wb, response);
    }

    @RequestMapping("/workbench/activity/exportActivitySelective.do") //选择导出市场活动;
    public void exportActivitySelective(String[] id, HttpServletResponse response) throws Exception {
        List<Activity> activityList = activityService.queryActivityByIds(id);
        HSSFWorkbook wb = HSSFUtils.getExcelFromList(activityList);
        /*String fileName = "activity_" + DateFormatUtils.getDateTimeStamp(new Date()) + ".xls";
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
        response.setContentType("application/octet-stream;charset=utf-8");
        OutputStream out = response.getOutputStream();
        wb.write(out);
        wb.close();
        out.flush();*/
        exportWorkbookHandler(wb, response);
    }

    //帮助导出excel文件的方法
    public void exportWorkbookHandler(HSSFWorkbook wb, HttpServletResponse response) throws Exception {
        String fileName = "activity_" + DateFormatUtils.getDateTimeStamp(new Date()) + ".xls";
        //设置相应头, 浏览器接收到响应后会打开文件下载窗口, 而不是默认的行为->直接打开;
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
        //设置内容属性, 告知浏览器本次返回的响应信息是文件;
        response.setContentType("application/octet-stream;charset=utf-8");
        OutputStream out = response.getOutputStream();
        wb.write(out);

        //资源谁开启, 谁关闭;
        wb.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile, HttpSession session) throws IOException {
        ReturnObject returnObject = null;
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);

        String serverFilePath = "F:/test/serverDir/" + activityFile.getName() + "_" + DateFormatUtils.getSysDateTimeStamp() + ".xls";
        //将文件保存至服务端
        activityFile.transferTo(new File(serverFilePath));

        FileInputStream fis = new FileInputStream(serverFilePath);
        HSSFWorkbook wb = new HSSFWorkbook(fis);
        //使用工具方法得到实体类集合对象, create_by, owner字段默认使用系统中当前用户的id赋值
        List<Activity> activityList = HSSFUtils.getActivityListFromWorkbook(wb, user);
        try {
            int rows = activityService.saveCreateActivityByList(activityList);
            returnObject = ReturnObject.getReturnObjectByRows(rows, rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        } finally {
            //关闭资源
            wb.close();
            fis.close();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/toDetail.do")
    public ModelAndView toDetail(String id) { //跳转到市场活动明细页面
        ModelAndView mv = new ModelAndView();
        mv.addObject("activity", activityService.queryActivityForDetailById(id));
        mv.addObject("activityRemarkList", activityRemarkService.queryActivityRemarkForDetailByActivityId(id));
        mv.setViewName("workbench/activity/detail");
        return mv;
    }
}


