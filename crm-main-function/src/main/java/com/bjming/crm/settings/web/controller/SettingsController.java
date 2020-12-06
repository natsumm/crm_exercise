package com.bjming.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 2020/12/06 by AshenOne
 */
@Controller
public class SettingsController {
    //跳转至系统设置主页面
    @RequestMapping("/settings/toIndex.do")
    public String toIndex() {
        return "settings/index";
    }
}


