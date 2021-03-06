package com.bjming.crm.workbench.mapper;

import com.bjming.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Dec 07 09:19:58 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Dec 07 09:19:58 CST 2020
     */
    int insert(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Dec 07 09:19:58 CST 2020
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Dec 07 09:19:58 CST 2020
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Dec 07 09:19:58 CST 2020
     */
    int updateByPrimaryKeySelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Dec 07 09:19:58 CST 2020
     */
    int updateByPrimaryKey(Activity record);

    //--------------------------------------------------------------------------------------
    /**
     * 从实体类中插入一条记录
     */
    int insertActivity(Activity activity);

    /**
     * 根据条件分页查询市场活动
     * @param map name, owner,startDate,endDate,pageNo,pageSize
     * @return activityList
     */
    List<Activity> selectActivityByConditionForPage(Map<String, Object> map);

    /**
     * 查询符合条件的记录条数
     * @param map
     * @return totalRows
     */
    int selectCountOfActivityByCondition(Map<String, Object> map);

    /**
     * 从id数组中删除多条记录
     * @param ids id
     * @return rows
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据主键值查询活动记录
     *
     * @param id
     * @return
     */
    Activity selectActivityById(String id);

    /**
     * 从实体类中更新一条记录
     *
     * @param activity
     * @return
     */
    int updateActivity(Activity activity);

    /**
     * 查询表中所有的市场活动记录, 外键字段使用连接查询;
     *
     * @return
     */
    List<Activity> selectAllActivityForDetail();

    /**
     * 根据id数组查询多条市场活动记录;
     *
     * @param ids
     * @return
     */
    List<Activity> selectActivityByIds(String[] ids);

    /**
     * 从集合中插入多条市场活动记录
     *
     * @param list activityList
     * @return rows
     */
    int insertActivitiesByList(List<Activity> list);

    /**
     * 根据主键字段查询一条市场活动记录
     *
     * @param id id
     * @return activity
     */
    Activity selectActivityForDetailById(String id);

    /**
     * 通过线索id查询关联的多条市场活动记录
     *
     * @param clueId
     * @return activityList
     */
    List<Activity> selectActivityForDetailByClueId(String clueId);

    /**
     * 根据名称模糊查询市场活动, 并排除已经关联过的市场活动, 外键字段采用连接查询
     *
     * @param name
     * @param clueId
     * @return activityList
     */
    List<Activity> selectActivityForDetailByNameAndClueId(@Param("name") String name, @Param("clueId") String clueId);

    /**
     * 从id数组中查询多条市场记录, 外键字段采用连接查询
     *
     * @param ids
     * @return
     */
    List<Activity> selectActivityForDetailByIds(String[] ids);

    /**
     * 根据名称模糊查询市场活动, 并查询关联过的市场活动, 外键字段采用连接查询
     *
     * @param name
     * @param clueId
     * @return
     */
    List<Activity> selectActivityForConvertByNameAndClueId(@Param("name") String name, @Param("clueId") String clueId);

    /**
     * 根据名称模糊查询市场活动, owner使用连接查询
     *
     * @param name
     * @return
     */
    List<Activity> selectActivityByName(String name);
}