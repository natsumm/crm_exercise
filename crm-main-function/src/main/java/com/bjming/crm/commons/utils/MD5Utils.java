package com.bjming.crm.commons.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Author: AshenOne
 * Time: 11/23/2020 16:44
 */
public class MD5Utils {
    public static String stringToMD5(String buffer) {
        String string = null;
        char[] hexDigest = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");
            md.update(buffer.getBytes());
            byte[] dataArray = md.digest(); //16个字节的长整数

            char[] str = new char[2 * 16];
            int k = 0;

            for (int i = 0; i < 16; i++) {
                byte b = dataArray[i];
                str[k++] = hexDigest[b >>> 4 & 0xf];//高4位
                str[k++] = hexDigest[b & 0xf];//低4位
            }
            string = new String(str);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return string;
    }
}

