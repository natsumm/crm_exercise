package com.bjming.crm.settings.service;

import com.bjming.crm.settings.domain.User;

import java.util.Map;

/**
 * tbl_user
 * Author: AshenOne
 * Time: 12/02/2020 15:50
 */
public interface UserService {
    //根据用户名和密码查询用户对象
    User queryUserByActAndPwd(Map<String, Object> map);
}


