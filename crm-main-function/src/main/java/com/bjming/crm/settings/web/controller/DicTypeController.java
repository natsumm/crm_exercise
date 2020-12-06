package com.bjming.crm.settings.web.controller;

import com.bjming.crm.commons.domain.ReturnObject;
import com.bjming.crm.settings.domain.DicType;
import com.bjming.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * /WEB-INF/pages/settings/dictionary/type/
 * 2020/12/06 by AshenOne
 */
@Controller
public class DicTypeController {
    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping("/settings/dictionary/type/toIndex.do")
    public String toIndex(Model model) {
        //查询表中所有的数据字典类型并放入request中
        model.addAttribute("dicTypeList", dicTypeService.queryAllDicType());
        return "settings/dictionary/type/index";
    }

    //跳转至"创建数据字典界面"
    @RequestMapping("/settings/dictionary/type/toSave.do")
    public String toSave() {
        return "settings/dictionary/type/save";
    }

    @RequestMapping("/settings/dictionary/type/queryDicTypeByCode.do")
    @ResponseBody
    public Object queryDicTypeByCode(String code) {
        DicType dicType = dicTypeService.queryDicTypeByCode(code);
        ReturnObject returnObject = null;
        if (dicType == null) { //没有查询结果, 表示编码不重复, "1"
            returnObject = ReturnObject.getSuccessReturnObject();
        } else {
            returnObject = ReturnObject.getFailReturnObject("编码重复, 请检查..");
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/type/saveCreateDicType.do")
    @ResponseBody
    public Object saveCreateDicType(DicType dicType) {
        ReturnObject returnObject = null;
        try {
            int rows = dicTypeService.saveCreateDicType(dicType);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/type/deleteDicTypeByCodes.do")
    @ResponseBody
    public Object deleteDicTypeByCodes(String[] code) {
        ReturnObject returnObject = null;
        try {
            int rows = dicTypeService.deleteDicTypeByCodes(code);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/type/toEdit.do")
    public String toEdit(Model model, String code) {
        model.addAttribute("dicType", dicTypeService.queryDicTypeByCode(code));
        return "settings/dictionary/type/edit";
    }

    @RequestMapping("/settings/dictionary/type/saveEditDicType.do")
    @ResponseBody
    public Object saveEditDicType(DicType dicType) {
        ReturnObject returnObject = null;
        try {
            int rows = dicTypeService.saveEditDitType(dicType);
            returnObject = ReturnObject.getReturnObjectByRows(rows);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject = ReturnObject.getFailReturnObject();
        }
        return returnObject;
    }
}


