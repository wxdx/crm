import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import java.io.*;

public class ReadExcelUtil {

    public static void readExcel(InputStream input) throws Exception  {
        Workbook workbook = null;
        try {
            workbook = WorkbookFactory.create(input);

            Sheet sheet = workbook.getSheetAt(0); // 获得第一个表单

            int totalRow = sheet.getLastRowNum();// 得到excel的总记录条数

            int totalCell = sheet.getRow(0).getPhysicalNumberOfCells();// 表头总共的列数

            System.out.println("总行数:" + totalRow + ",总列数:" + totalCell);

            for (int i = 1; i <= totalRow; i++) {// 遍历行

                for (int j = 0; j < totalCell; j++) {

                    sheet.getRow(i).getCell(j).setCellType(Cell.CELL_TYPE_STRING);

                    System.out.print(sheet.getRow(i).getCell(j).getStringCellValue() + " ");
                }
                System.out.println();
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
