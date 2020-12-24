package com.bjming.crm.bundle;

import org.junit.Test;

import java.util.Enumeration;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * 2020/12/14 by AshenOne
 */
public class ResourceBundleTest {

    @Test
    public void testBundle(){
        ResourceBundle bundle=ResourceBundle.getBundle("possibility");
        String value = bundle.getString("价值建议");
        System.out.println("value = " + value);
        Enumeration<String> keys = bundle.getKeys();
        while(keys.hasMoreElements()){
            System.out.println("keys.nextElement() = " + keys.nextElement());
        }

        Locale locale = bundle.getLocale();
        System.out.println("locale = " + locale);
        System.out.println("locale.getClass().getName() = " + locale.getClass().getName());
    }
}


