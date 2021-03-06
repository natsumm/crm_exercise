package com.bjming.crm.workbench.mapper;

import com.bjming.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Wed Dec 09 18:15:18 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Wed Dec 09 18:15:18 CST 2020
     */
    int insert(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Wed Dec 09 18:15:18 CST 2020
     */
    int insertSelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Wed Dec 09 18:15:18 CST 2020
     */
    Clue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Wed Dec 09 18:15:18 CST 2020
     */
    int updateByPrimaryKeySelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Wed Dec 09 18:15:18 CST 2020
     */
    int updateByPrimaryKey(Clue record);

    /**
     * 从实体类中插入一条记录
     *
     * @param clue
     * @return rows
     */
    int insertClue(Clue clue);
    //***********************************************************

    /**
     * 根据条件分页查询线索
     *
     * @param map param: fullname, company, phone, mphone, source, owner, state, beginNo, pageSize
     * @return clueList
     */
    List<Clue> selectClueByConditionForPage(Map<String, Object> map);

    /**
     * 根据条件查询对应clue的记录数目
     *
     * @param map 同上
     * @return totalRows
     */
    int selectCountOfClueByCondition(Map<String, Object> map);

    /**
     * 根据主键字段查询线索明细, 外间字段采用连接查询
     *
     * @param id 主键字段
     * @return clue
     */
    Clue selectClueForDetailById(String id);

    /**
     * 根据id删除线索记录, 可以批量删除
     *
     * @param ids
     * @return rows
     */
    int deleteClueByIds(String[] ids);

    /**
     * 根据id查询clue, 外键字段直接查询值;
     *
     * @param id
     * @return
     */
    Clue selectClueById(String id);

    /**
     * 从实体类中更新一条记录
     *
     * @param clue
     * @return
     */
    int updateClue(Clue clue);

    /**
     * 根据线索id删除一条记录
     *
     * @param clue
     * @return
     */
    int deleteClueById(String id);
}