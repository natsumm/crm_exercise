package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * 2020/12/07 by AshenOne
 */
public interface ActivityService {
    //从实体类中插入一条记录
    int saveCreateActivity(Activity activity);
    //根据条件分页查询市场活动
    List<Activity> queryActivityByConditionForPage(Map<String, Object> map);
    //查询符合条件的市场活动记录数目
    int queryCountOfActivityByCondition(Map<String, Object> map);
    //从id数组中删除多条市场活动记录
    int deleteActivityByIds(String[] ids);
}


