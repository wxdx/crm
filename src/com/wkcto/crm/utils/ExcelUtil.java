package com.wkcto.crm.utils;

import org.apache.poi.hssf.usermodel.*;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;


public class ExcelUtil {
    /**
     *
     * @param sheetName
     * @param clzz
     * @param dataList
     * @return
     */
    public static HSSFWorkbook export(String sheetName, Class clzz, List dataList) {
        // 创建一个Excel文件
        HSSFWorkbook workbook = new HSSFWorkbook();
        try {

            // 创建一个工作表
            HSSFSheet sheet = workbook.createSheet(sheetName);

            // 添加表头行
            HSSFRow hssfRow = sheet.createRow(0);

            // 设置单元格格式居中
            HSSFCellStyle cellStyle = workbook.createCellStyle();
            cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

            // 添加表头内容
            Field[] fields = clzz.getDeclaredFields();

            for (int i = 0;i < fields.length;i++){
                Field field = fields[i];
                String fieldName = field.getName();
                HSSFCell cell = hssfRow.createCell(i);
                cell.setCellValue(fieldName);
                cell.setCellStyle(cellStyle);
            }


            // 添加数据内容
            for (int i = 0; i < dataList.size(); i++) {
                HSSFRow row = sheet.createRow((int) i + 1);
                Object o = dataList.get(i);

                // 创建单元格，并设置值
                for (int j = 0;j < fields.length;j++){
                    HSSFCell cell = row.createCell(j);
                    String fieldName = fields[j].getName();
                    String getMethodName = "get" + fieldName.substring(0,1).toUpperCase()+fieldName.substring(1);
                    Method getMethod = clzz.getDeclaredMethod(getMethodName);
                    cell.setCellValue(getMethod.invoke(o) == null?"":getMethod.invoke(o).toString());
                    cell.setCellStyle(cellStyle);
                }

            }
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        return workbook;
    }
}
