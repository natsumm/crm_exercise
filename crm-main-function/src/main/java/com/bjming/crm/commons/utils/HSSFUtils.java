package com.bjming.crm.commons.utils;

import com.bjming.crm.settings.domain.User;
import com.bjming.crm.workbench.domain.Activity;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.formula.functions.Index;
import org.springframework.util.ObjectUtils;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * poi的HSSF工具类, 帮助处理excel文件
 * 2020/12/08 by AshenOne
 */
public class HSSFUtils {

    public static HSSFWorkbook getExcelFromList(List list) throws IllegalAccessException {
        HSSFWorkbook wb = new HSSFWorkbook();
        if (ObjectUtils.isEmpty(list)) return wb;
        Class classFile = list.get(0).getClass();
        Map<String, String> columnMap = null; //获取映射的 字段-中文 map
        if ("Activity".equals(classFile.getSimpleName())) {
            columnMap = activityColumnMap();
        }
        Field[] fieldArray = classFile.getDeclaredFields();
        HSSFRow row = null;
        HSSFCell cell = null;
        Field field = null;
        Object value = null;
        HSSFSheet sheet = wb.createSheet("activityList");
        HSSFRow columnRow = sheet.createRow(0);

        //遍历集合, 每条记录对应一行
        for (int i = 0; i < list.size(); i++) {
            Object obj = list.get(i);
            row = sheet.createRow(i + 1);
            //遍历字段数组
            for (int j = 0; j < fieldArray.length; j++) {
                field = fieldArray[j];
                field.setAccessible(true);
                if (i == 0) {
                    //生成标题行
                    cell = columnRow.createCell(j);
                    if (columnMap != null) {
                        cell.setCellValue(columnMap.get(field.getName()));
                    } else {
                        cell.setCellValue(field.getName());
                    }
                }
                //生成数据行
                cell = row.createCell(j);
                value = field.get(obj);
                if (value != null) {
                    cell.setCellValue(value.toString());
                }

            }
        }
        return wb;
    }

    //获取 字段-中文名 的映射
    private static Map<String, String> activityColumnMap() {
        Map<String, String> map = new HashMap<>();
        map.put("id", "编号");
        map.put("owner", "所有者");
        map.put("name", "名称");
        map.put("startDate", "开始日期");
        map.put("endDate", "结束日期");
        map.put("cost", "花费");
        map.put("description", "描述");
        map.put("createTime", "创建时间");
        map.put("createBy", "创建人");
        map.put("editTime", "修改时间");
        map.put("editBy", "修改人");
        return map;
    }

    /**
     * 根据cell的type来获取值
     *
     * @return value
     */
    public static String getCellValueForStr(HSSFCell cell) {
        String value = "";
        switch (cell.getCellType()) {
            case HSSFCell.CELL_TYPE_STRING:
                value = "" + cell.getStringCellValue();
                break;
            case HSSFCell.CELL_TYPE_FORMULA:
                value = "" + cell.getCellFormula();
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                value = "" + cell.getBooleanCellValue();
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:
                value = "" + cell.getNumericCellValue();
                break;
            default: //空白和错误类型直接赋值空串;
                value = "";
        }
        return value;
    }

    /**
     * 从workbook对象获取activityList
     *
     * @param wb   workbook
     * @param user 用户对象
     * @return activityList
     */
    public static List<Activity> getActivityListFromWorkbook(HSSFWorkbook wb, User user) {
        HSSFSheet sheet = wb.getSheetAt(0);
        HSSFRow row = null;
        HSSFCell cell = null;
        List<Activity> activityList = new ArrayList<>();
        Activity activity = null;
        for (int i = 1; i < sheet.getPhysicalNumberOfRows(); i++) {
            row = sheet.getRow(i);
            activity = new Activity();
            activity.setId(UUIDUtils.getUUID());
            activity.setCreateTime(DateFormatUtils.getSysDateTime());
            activity.setCreateBy(user.getId());
            activity.setOwner(user.getId());
            for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
                cell = row.getCell(j);
                String value = HSSFUtils.getCellValueForStr(cell);
                setActivityAttr(j, value, activity);
            }
            activityList.add(activity);
        }
        return activityList;
    }

    /**
     * 根据单元格的位置, 为activity对象赋值
     *
     * @param index    单元格位置
     * @param value    单元格的值
     * @param activity activity对象
     */
    private static void setActivityAttr(int index, String value, Activity activity) {
        switch (index) {
            case 0:
                activity.setName(value);
                break;
            case 1:
                activity.setStartDate(value);
                break;
            case 2:
                activity.setEndDate(value);
                break;
            case 3:
                activity.setCost(value);
                break;
            case 4:
                activity.setDescription(value);
                break;

        }
    }
}


