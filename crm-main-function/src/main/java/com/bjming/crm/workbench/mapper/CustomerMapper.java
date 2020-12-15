package com.bjming.crm.workbench.mapper;

import com.bjming.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri Dec 11 20:45:13 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri Dec 11 20:45:13 CST 2020
     */
    int insert(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri Dec 11 20:45:13 CST 2020
     */
    int insertSelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri Dec 11 20:45:13 CST 2020
     */
    Customer selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri Dec 11 20:45:13 CST 2020
     */
    int updateByPrimaryKeySelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri Dec 11 20:45:13 CST 2020
     */
    int updateByPrimaryKey(Customer record);

    //*******************************
    /**
     * 从实体类中插入一条记录
     */
    int insertCustomer(Customer customer);

    /**
     * 根据名称模糊查询客户
     *
     * @param name
     * @return customerList
     */
    List<String> selectCustomerNameByName(String name);

    /**
     * 根据条件进行分页查询客户
     *
     * @param map name, owner, phone, website, beginNo, pageSize
     * @return customerList
     */
    List<Customer> selectCustomerByConditionForPage(Map<String, Object> map);

    /**
     * 查询符合条件的记录数目
     *
     * @param map name, owner, phone, website, beginNo, pageSize
     * @return count of customer
     */
    int selectCountOfCustomerByCondition(Map<String, Object> map);

    /**
     * 根据id数组删除多条客户记录
     *
     * @param ids
     * @return
     */
    int deleteCustomerByIds(String[] ids);

    /**
     * 根据id查询客户
     *
     * @param id
     * @return
     */
    Customer selectCustomerById(String id);

    /**
     * 从实体类中更新一条记录
     *
     * @param customer
     * @return
     */
    int updateCustomer(Customer customer);

    /**
     * 根据id查询客户, 外键字段采用连接查询
     *
     * @param id
     * @return
     */
    Customer selectCustomerForDetailById(String id);

    /**
     * 根据name精确查询客户, 现实世界中 公司的全名是唯一的, 需要在工商部注册
     *
     * @param name
     * @return
     */
    Customer selectCustomerByName(String name);
}