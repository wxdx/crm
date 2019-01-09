import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;

public class ReadExcelUtil2 {

    public static <T> void readExcel(InputStream input, Class clzz, List<T> dataList) throws Exception  {
        Workbook workbook = null;
        try {
            workbook = WorkbookFactory.create(input);

            Sheet sheet = workbook.getSheetAt(0); // 获得第一个表单

            int totalRow = sheet.getLastRowNum();// 得到excel的总记录条数

            int totalCell = sheet.getRow(0).getPhysicalNumberOfCells();// 表头总共的列数

            System.out.println("总行数:" + totalRow + ",总列数:" + totalCell);

            Field[] fields = clzz.getDeclaredFields();
            for (int i = 1; i <= totalRow; i++) {// 遍历行
                T o = (T)clzz.newInstance();
                for (int j = 0; j < totalCell; j++) {
                    
                    Field file = fields[j];
                    String fileName = file.getName();
                    String methodFileName = "set" + fileName.substring(0,1).toUpperCase() + fileName.substring(1);
                    Method setMenthod = clzz.getDeclaredMethod(methodFileName,String.class);

                    sheet.getRow(i).getCell(j).setCellType(Cell.CELL_TYPE_STRING);
                    setMenthod.invoke(o,sheet.getRow(i).getCell(j).getStringCellValue());
                }
                dataList.add(o);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            throw new Exception(ex);
        }finally {

            try {
                input.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
