package com.bjming.crm.settings.web.controller;

import com.bjming.crm.commons.contsants.MyConstants;
import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.MD5Utils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * /WEB-INF/pages/settings/qx/user/
 * Author: AshenOne
 * Time: 12/02/2020 15:30
 */
@Controller
public class UserController {
    @Autowired
    private UserService userService;

    //跳转至登录界面
    @RequestMapping(value = "/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    //根据用户名和密码查询用户
    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, Boolean isRemPwd,
                        HttpServletRequest request,
                        HttpServletResponse response,
                        HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        ReturnObject returnObject = null;
        String remoteAddr = request.getRemoteAddr();
        map.put("loginAct", loginAct);
        map.put("loginPwd", MD5Utils.stringToMD5(loginPwd));
        User user = userService.queryUserByActAndPwd(map);
        if (user == null) {//用户名和密码错误
            returnObject = ReturnObject.getFailReturnObject("用户名或者密码错误");
        } else if (DateFormatUtils.getSysDateTime().compareTo(user.getExpireTime()) > 0) {
            returnObject = ReturnObject.getFailReturnObject("用户已过期, 请联系管理员");
        } else if (MyConstants.USER_STATE_LOCKED.equals(user.getLockState())) {
            returnObject = ReturnObject.getFailReturnObject("用户被锁定, 请联系管理员");
        } else if (!user.getAllowIps().contains(remoteAddr)) {
            returnObject = ReturnObject.getFailReturnObject("ip受限, 请联系管理员");
        } else {
            returnObject = ReturnObject.getSuccessReturnObject();
            //十天记住密码
            if (isRemPwd != null && isRemPwd) {
                Cookie act = new Cookie("loginAct", loginAct);
                Cookie pwd = new Cookie("loginPwd", loginPwd);
                act.setMaxAge(60 * 60 * 24 * 10);
                pwd.setMaxAge(60 * 60 * 24 * 10);
                response.addCookie(act);
                response.addCookie(pwd);
            }
            //将用户对象放入session中
            session.setAttribute(MyConstants.SESSION_USER, user);
        }
        return returnObject;
    }
}


