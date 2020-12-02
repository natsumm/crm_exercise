package com.bjming.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * /WEB-INF/pages/
 * Author: AshenOne
 * Time: 12/02/2020 15:25
 */
@Controller
public class IndexController {
    //跳转至/WEB-INF/pages/index.jsp
    @RequestMapping(value = "/")
    public String toIndex(){
        return "index";
    }
}


