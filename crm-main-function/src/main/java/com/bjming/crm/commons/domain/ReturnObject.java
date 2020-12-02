package com.bjming.crm.commons.domain;

import com.bjming.crm.commons.contsants.MyConstants;

/**
 * 通用的返回结果类
 * Author: AshenOne
 * Time: 11/09/2020 9:43
 */
public class ReturnObject {
    private String code;//表示请求是否成功
    private String msg;//请求失败的友好提示
    private Object retData; //表示数据

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }

    /**
     * 根据影响记录条数返回 returnObject对象, 成功时将影响记录条数写入retData,
     * 失败时的msg为-->"系统忙, 请稍后重试....."
     * @param rows rows>0 success, rows=0 fail
     * @return returnObject
     */
    public static ReturnObject getReturnObjectByRows(int rows) {
        if (rows > 0) return getSuccessReturnObject(rows);
        return getFailReturnObject();
    }

    public static ReturnObject getReturnObjectByRows(int rows, Object targetRetData) {
        if (rows > 0) return getSuccessReturnObject(targetRetData);
        return getFailReturnObject();
    }

    public static ReturnObject getSuccessReturnObject(){
        return getSuccessReturnObject(null);
    }

    public static ReturnObject getSuccessReturnObject(Object retData) {
        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(MyConstants.AJAX_RETURN_CODE_SUCCESS);
        returnObject.setRetData(retData);
        return returnObject;
    }

    public static ReturnObject getFailReturnObject(String message) {
        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(MyConstants.AJAX_RETURN_CODE_FAIL);
        returnObject.setMsg(message);
        return returnObject;
    }

    public static ReturnObject getFailReturnObject() {
        return getFailReturnObject("系统忙,请稍后重试...");
    }
}


