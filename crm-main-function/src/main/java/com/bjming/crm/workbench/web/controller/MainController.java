package com.bjming.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * /WEB-INF/pages/workbench/main/
 * 2020/12/06 by AshenOne
 */
@Controller
public class MainController {
    @RequestMapping("/workbench/main/toIndex.do")
    public String toIndex(){
        return "workbench/main/index";
    }
}


