package com.bjming.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 时间格式转化工具类
 * 返回系统时间的19位标准格式字符串
 * Author: AshenOne
 * Time: 11/07/2020 19:50
 */
public class DateFormatUtils {
    /**
     * 返回系统时间的19位标准格式字符串
     */
    public static String getSysDateTime(){
        return getDateTime(new Date());
    }

    /**
     * 获取当前系统时间的yyyyMMddHHmmss格式的时间戳
     *
     * @return
     */
    public static String getSysDateTimeStamp() {
        return getDateTimeStamp(new Date());
    }

    /**
     * yyyy-MM-dd HH:mm:ss
     */
    public static String getDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }

    /**
     * 获取 yyyyMMddHHmmss的日期时间戳
     */
    public static String getDateTimeStamp(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        return sdf.format(date);
    }
}


