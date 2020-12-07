package com.bjming.crm.settings.service.impl;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.settings.mapper.UserMapper;
import com.bjming.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Author: AshenOne
 * Time: 12/02/2020 15:54
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User queryUserByActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByActAndPwd(map);
    }

    @Override
    public List<User> queryAllAvailableUsers() {
        return userMapper.selectAllAvailableUsers(DateFormatUtils.getSysDateTime(), MyConstants.USER_STATE_NOT_LOCKED);
    }
}


