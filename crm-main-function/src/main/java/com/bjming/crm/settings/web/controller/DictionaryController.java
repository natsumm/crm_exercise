package com.bjming.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 2020/12/06 by AshenOne
 */
@Controller
public class DictionaryController {

    //跳转至数据字典主页面
    @RequestMapping("/settings/dictionary/toIndex.do")
    public String toIndex() {
        return "settings/dictionary/index";
    }
}


