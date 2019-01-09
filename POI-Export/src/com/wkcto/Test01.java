package com.wkcto;


import com.wkcto.domain.Activity;
import com.wkcto.utils.ExcelUtil;
import com.wkcto.utils.SqlSeesionUtil;
import org.apache.ibatis.session.SqlSession;
import org.apache.poi.hssf.usermodel.*;

import java.io.FileOutputStream;
import java.io.OutputStream;

import java.util.List;

public class Test01 {
    public static void main(String[] args) {
        SqlSession sqlSession = null;
        try {
            sqlSession = SqlSeesionUtil.getCurrentSqlSession();

            List<Activity> activityList = sqlSession.selectList("getAll");


            HSSFWorkbook workbook = ExcelUtil.export("市场活动1",Activity.class,activityList);
            // 保存Excel文件
            try {
                OutputStream outputStream = new FileOutputStream("e:/activity11.xls");
                workbook.write(outputStream);
                outputStream.close();
            } catch (Exception e) {
                e.printStackTrace();
            }


            sqlSession.commit();
        } catch (Exception e){
            SqlSeesionUtil.rollBack(sqlSession);
            e.printStackTrace();
        } finally {
            SqlSeesionUtil.close(sqlSession);
        }
    }

}
