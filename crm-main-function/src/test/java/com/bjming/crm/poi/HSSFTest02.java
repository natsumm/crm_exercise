package com.bjming.crm.poi;

import com.bjming.crm.commons.utils.HSSFUtils;
import com.bjming.crm.settings.domain.User;
import com.bjming.crm.workbench.domain.Activity;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.junit.Test;

import java.io.FileInputStream;
import java.util.List;

/**
 * 2020/12/08 by AshenOne
 */
public class HSSFTest02 {
    @Test
    public void test01() throws Exception {
        FileInputStream fis = new FileInputStream("F:\\test\\clientDir\\activity_20201208201426 - 副本.xls");
        HSSFWorkbook wb = new HSSFWorkbook(fis);
        HSSFSheet sheet = wb.getSheetAt(0);
        List<Activity> activityList = HSSFUtils.getActivityListFromWorkbook(wb, new User());
        for (Activity activity : activityList) {
            System.out.println("activity = " + activity);
        }
    }
}


