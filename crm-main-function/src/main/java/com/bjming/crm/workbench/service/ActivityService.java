package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * 2020/12/07 by AshenOne
 */
public interface ActivityService {
    /**
     * 从实体类中插入一条记录
     */
    int saveCreateActivity(Activity activity);

    /**
     * 根据条件分页查询市场活动
     */
    List<Activity> queryActivityByConditionForPage(Map<String, Object> map);

    /**
     * 查询符合条件的市场活动记录数目
     */
    int queryCountOfActivityByCondition(Map<String, Object> map);

    /**
     * 从id数组中删除多条市场活动记录
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据主键从表中查询一条记录
     */
    Activity queryActivityById(String id);

    /**
     * 从实体类中更新一条记录
     */
    int saveEditActivity(Activity activity);

    /**
     * 查询表中所有的市场活动记录, 外键字段使用连接查询
     */
    List<Activity> queryAllActivityForDetail();

    /**
     * 根据id数组从表中查询多条市场活动记录;
     */
    List<Activity> queryActivityByIds(String[] ids);

    /**
     * 从实体类集合中插入多条市场活动记录
     *
     * @param activityList 实体类集合
     * @return rows
     */
    int saveCreateActivityByList(List<Activity> activityList);
}


