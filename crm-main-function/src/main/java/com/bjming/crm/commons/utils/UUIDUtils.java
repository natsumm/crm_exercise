package com.bjming.crm.commons.utils;

import java.util.UUID;

/**
 * Author: AshenOne
 * Time: 11/10/2020 14:13
 */
public class UUIDUtils {
    public static String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}


