package com.bjming.crm.workbench.mapper;

import com.bjming.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Fri Dec 11 21:39:09 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Fri Dec 11 21:39:09 CST 2020
     */
    int insert(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Fri Dec 11 21:39:09 CST 2020
     */
    int insertSelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Fri Dec 11 21:39:09 CST 2020
     */
    Contacts selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Fri Dec 11 21:39:09 CST 2020
     */
    int updateByPrimaryKeySelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Fri Dec 11 21:39:09 CST 2020
     */
    int updateByPrimaryKey(Contacts record);

    //*************************************************
    /**
     * 从实体类添加一条记录
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);

    /**
     * 通过名称模糊查询联系人
     *
     * @return
     */
    List<Contacts> selectContactsByFullname(String fullname);

    /**
     * 根据客户id查询多条联系人记录
     *
     * @param customerId
     * @return
     */
    List<Contacts> selectContactsForDetailByCustomerId(String customerId);

    /**
     * 根据主键字段删除一条数据
     *
     * @param id
     * @return
     */
    int deleteContactsById(String id);
}