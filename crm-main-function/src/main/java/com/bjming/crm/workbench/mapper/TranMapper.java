package com.bjming.crm.workbench.mapper;

import com.bjming.crm.workbench.domain.Tran;

public interface TranMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sat Dec 12 09:34:05 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sat Dec 12 09:34:05 CST 2020
     */
    int insert(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sat Dec 12 09:34:05 CST 2020
     */
    int insertSelective(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sat Dec 12 09:34:05 CST 2020
     */
    Tran selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sat Dec 12 09:34:05 CST 2020
     */
    int updateByPrimaryKeySelective(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sat Dec 12 09:34:05 CST 2020
     */
    int updateByPrimaryKey(Tran record);
    //********************************************

    /**
     * 从实体类中添加一条记录
     *
     * @param tran
     * @return
     */
    int insertTran(Tran tran);
}