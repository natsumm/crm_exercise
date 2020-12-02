package com.bjming.crm.commons.contsants;

/**
 * 自定义的一组常量
 * Author: AshenOne
 * Time: 11/11/2020 14:35
 */
public class MyConstants {
    //发起ajax请求返回的成功标志, 1->成功,0->失败
    public static final String AJAX_RETURN_CODE_SUCCESS = "1";
    public static final String AJAX_RETURN_CODE_FAIL = "0";

    //放在session作用域中user对象的key
    public static final String SESSION_USER = "sessionUser";

    //账户的锁定状态 0->锁定, 1->启用
    public static final String USER_STATE_LOCKED = "0";
    public static final String USER_STATE_NOT_LOCKED = "1";

    //备注的修改标记, 0->未修改, 1->已修改
    public static final String REMARK_EDIT_FLAG_NOT_MODIFIED = "0";
    public static final String REMARK_EDIT_FLAG_MODIFIED = "1";
}



