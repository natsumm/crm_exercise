package com.bjming.crm.workbench.web.controller;

import com.bjming.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * /WEB-INF/pages/workbench/chart/...
 * 2020/12/16 by AshenOne
 */
@Controller
public class ChartController {
    @Autowired
    private TranService tranService;

    @RequestMapping("/workbench/chart/transaction/toTransactionIndex.do")
    public String toTransactionIndex() {
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage.do")
    @ResponseBody
    public Object queryCountOfTranGroupByStage() {
        return tranService.queryCountOfTranGroupByStage();
    }
}


