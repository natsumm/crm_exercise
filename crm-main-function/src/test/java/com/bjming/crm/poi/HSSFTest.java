package com.bjming.crm.poi;

import com.bjming.crm.commons.utils.DateFormatUtils;
import com.bjming.crm.commons.utils.HSSFUtils;
import com.bjming.crm.workbench.domain.Activity;
import com.bjming.crm.workbench.mapper.ActivityMapper;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.File;
import java.util.Date;
import java.util.List;

/**
 * 2020/12/08 by AshenOne
 */
public class HSSFTest {
    public static void main(String[] args) throws Exception {
        ApplicationContext context=new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityMapper mapper = (ActivityMapper) context.getBean("activityMapper");
        List<Activity> activityList=mapper.selectAllActivityForDetail();
        HSSFWorkbook wb=HSSFUtils.getExcelFromList(activityList);

        wb.write(new File("F:\\test", "activity_"+ DateFormatUtils.getDateTimeStamp(new Date())+".xls"));
        wb.close();
    }
}


