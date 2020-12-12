package com.bjming.crm.commons.utils;

import java.lang.reflect.Field;
import java.util.HashSet;
import java.util.Set;

/**
 * 线索转化的工具类
 * 2020/12/11 by AshenOne
 */
public class ClueConvertUtils {

    /**
     * 将同名的属性相互转换,
     * 并根据类型进行排除, 如果是remark类型, 排除id, customerId, contactsId,
     * 如果是其他类型, 排除id, createBy, createTime, editBy, editTime, owner
     * 排除的属性除id外需要手动赋值, 属性名不一致的情况也需要手动赋值;
     *
     * @param origin
     * @param dest
     * @throws Exception
     */
    public static void injectAttributeValue(Object origin, Object dest) throws Exception {
        Field[] originField = origin.getClass().getDeclaredFields();
        Class destFile=dest.getClass();
        Field[] destField = destFile.getDeclaredFields();
        Set<String> notInjectAttribute = null;
        if (destFile.getSimpleName().toLowerCase().contains("remark")) {
            notInjectAttribute = getRemarkNotInjectAttributes();
        } else {
            notInjectAttribute = getOtherNotInjectAttributes();
        }

        for (Field of : originField) {
            of.setAccessible(true);
            for (Field df : destField) {
                df.setAccessible(true);
                if (df.getName().equals(of.getName()) && !notInjectAttribute.contains(df.getName())) {
                    df.set(dest, of.get(origin));
                } else if (df.getName().equalsIgnoreCase("id")) {
                    df.set(dest, UUIDUtils.getUUID());
                }
            }
        }
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


