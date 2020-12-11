package com.bjming.crm.commons.utils;

import java.lang.reflect.Field;
import java.util.HashSet;
import java.util.Set;

/**
 * 2020/12/11 by AshenOne
 */
public class ClueConvertUtils {

    public static Object injectAttributeValue(Object origin, Class destFile, String dest) throws Exception {
        Field[] originField = origin.getClass().getDeclaredFields();
        Field[] destField = destFile.getDeclaredFields();
        Object destObject = destFile.newInstance();
        Set<String> notInjectAttribute = null;
        if (dest.toLowerCase().contains("remark")) {
            notInjectAttribute = getRemarkNotInjectAttributes();
        } else {
            notInjectAttribute = getOtherNotInjectAttributes();
        }

        for (Field of : originField) {
            of.setAccessible(true);
            for (Field df : destField) {
                df.setAccessible(true);
                if (df.getName().equals(of.getName()) && !notInjectAttribute.contains(df.getName())) {
                    //System.out.println("of.get(origin) = " + of.get(origin));
                    df.set(destObject, of.get(origin));
                }
            }
        }
        return destObject;
    }

    private static Set<String> getRemarkNotInjectAttributes() {
        Set<String> set = new HashSet<>();
        set.add("id");
        set.add("customerId");
        set.add("contactsId");
        return set;
    }

    private static Set<String> getOtherNotInjectAttributes() {
        Set<String> set = new HashSet<>();
        set.add("id");
        set.add("createBy");
        set.add("createTime");
        set.add("editBy");
        set.add("editTime");
        set.add("owner");
        return set;
    }
}


