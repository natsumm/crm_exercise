package com.bjming.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * /WEB-INF/pages/workbench/
 * Author: AshenOne
 * Time: 12/02/2020 16:51
 */
@Controller
public class WorkbenchController {
    @RequestMapping("/workbench/toIndex.do")
    public String toIndex(){
        return "workbench/index";
    }
}


