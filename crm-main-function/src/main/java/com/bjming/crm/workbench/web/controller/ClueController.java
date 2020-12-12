package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.UUIDUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.settings.service.DicValueService;
import com.bjming.crm.settings.service.UserService;
import com.bjming.crm.workbench.domain.Activity;
import com.bjming.crm.workbench.domain.Clue;
import com.bjming.crm.workbench.domain.ClueActivityRelation;
import com.bjming.crm.workbench.domain.Tran;
import com.bjming.crm.workbench.service.ActivityService;
import com.bjming.crm.workbench.service.ClueActivityRelationService;
import com.bjming.crm.workbench.service.ClueRemarkService;
import com.bjming.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 2020/12/09 by AshenOne
 */
@Controller
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/toIndex.do")
    public ModelAndView toIndex() {
        ModelAndView mv = new ModelAndView();
        mv.addObject("userList", userService.queryAllAvailableUsers());
        mv.addObject("appellationList", dicValueService.queryDicValuesByTypeCode("appellation"));
        mv.addObject("clueStateList", dicValueService.queryDicValuesByTypeCode("clueState"));
        mv.addObject("sourceList", dicValueService.queryDicValuesByTypeCode("source"));
        mv.setViewName("workbench/clue/index");
        return mv;
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session) {
        ReturnObject returnObject = null;
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        //封装前端未上传参数
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateFormatUtils.getSysDateTime());
        try {
            int rows = clueService.saveCreateClue(clue);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    @ResponseBody //param: fullname, company, phone, mphone, source, owner, state, beginNo, pageSize
    public Object queryClueByConditionForPage(@RequestParam Map<String, Object> map) {
        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        int totalRows = clueService.queryCountOfClueByCondition(map);
        map.clear();

        map.put("clueList", clueList);
        map.put("totalRows", totalRows);
        return map;
    }


    @RequestMapping("/workbench/clue/toDetail.do")
    public ModelAndView toDetail(String id) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("clue", clueService.queryClueForDetailById(id));
        mv.addObject("clueRemarkList", clueRemarkService.queryClueRemarkForDetailByClueId(id));
        mv.addObject("activityList", activityService.queryActivityForDetailByClueId(id));
        mv.setViewName("workbench/clue/detail");
        return mv;
    }

    @RequestMapping("/workbench/clue/queryActivityForDetailByNameAndClueId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameAndClueId(String name, String clueId) {
        return activityService.queryActivityForDetailByNameAndClueId(name, clueId);
    }

    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    @ResponseBody
    public Object deleteClueByIds(String[] id) {
        ReturnObject returnObject = null;
        try {
            int rows = clueService.deleteClueByIds(id);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveBundActivity.do")
    @ResponseBody //关联市场活动
    public Object saveBundActivity(String[] activityId, String clueId) {
        ReturnObject returnObject = null;
        //封装参数到relationList集合中
        List<ClueActivityRelation> relationList = new ArrayList<>();
        ClueActivityRelation relation = null;
        for (String actId : activityId) {
            relation = new ClueActivityRelation();
            relation.setId(UUIDUtils.getUUID());
            relation.setActivityId(actId);
            relation.setClueId(clueId);
            relationList.add(relation);
        }

        //调用service
        try {
            int rows = clueActivityRelationService.saveCreateClueActivityRelationByList(relationList);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
            if (MyConstants.AJAX_RETURN_CODE_SUCCESS.equals(returnObject.getCode())) {
                //成功插入后, 查询activity将其放入响应信息中
                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                returnObject.setRetData(activityList);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveUnbundActivity.do")
    @ResponseBody //解除绑定市场活动
    public Object saveUnbundActivity(ClueActivityRelation relation) {
        ReturnObject returnObject = null;
        try {
            int rows = clueActivityRelationService.deleteClueActivityRelationByActivityIdAndClueId(relation);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/toConvert.do")
    public ModelAndView toConvert(String id) { //跳转转换页面
        ModelAndView mv = new ModelAndView();
        //查询线索明细, 并查询数据字典值中关于交易阶段的信息
        mv.addObject("clue", clueService.queryClueForDetailById(id));
        mv.addObject("stageList", dicValueService.queryDicValuesByTypeCode("stage"));
        mv.setViewName("workbench/clue/convert");
        return mv;
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id) {
        return clueService.queryClueById(id);
    }

    @RequestMapping("/workbench/clue/saveEditClue.do")
    @ResponseBody
    public Object saveEditClue(Clue clue, HttpSession session) {
        ReturnObject returnObject = null;
        User user = (User) session.getAttribute(MyConstants.SESSION_USER);
        //封装前端未上传参数
        clue.setEditBy(user.getId());
        clue.setEditTime(DateFormatUtils.getSysDateTime());

        try {
            int rows = clueService.saveEditClue(clue);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryActivityForConvertByNameAndClueId.do")
    @ResponseBody
    public Object queryActivityForConvertByNameAndClueId(String name, String clueId) {
        return activityService.queryActivityForConvertByNameAndClueId(name, clueId);
    }

    @RequestMapping("/workbench/clue/saveConvertClue.do")
    @ResponseBody
    public Object saveConvertClue(String clueId, String isCreateTran, Tran tran, HttpSession session) {
        ReturnObject returnObject=null;

        //封装参数
        Map<String, Object> map=new HashMap<>();
        map.put("clueId", clueId);
        map.put("isCreateTran",isCreateTran);
        map.put(MyConstants.SESSION_USER,session.getAttribute(MyConstants.SESSION_USER));
        map.put("tran", tran);
        try {
            clueService.saveConvertClue(map);
            returnObject=ReturnObject.getSuccessReturnObject();
        }catch(Exception e){
            e.printStackTrace();
            returnObject=ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }
}


