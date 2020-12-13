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

    /**
     * 根据主键字段查询一条市场活动记录
     *
     * @param id id
     * @return activity
     */
    Activity queryActivityForDetailById(String id);

    /**
     * 根据线索主键字段, 查询关联的多条市场活动记录
     *
     * @param clueId
     * @return activityList
     */
    List<Activity> queryActivityForDetailByClueId(String clueId);

    /**
     * 根据名称模糊查询市场活动, 并排除已经关联的市场活动, 外见字段采用连接查询
     *
     * @param name
     * @param clueId
     * @return
     */
    List<Activity> queryActivityForDetailByNameAndClueId(String name, String clueId);

    List<Activity> queryActivityForDetailByIds(String[] ids);

    List<Activity> queryActivityForConvertByNameAndClueId(String name, String clueId);

    List<Activity> queryActivityByName(String name);
}


