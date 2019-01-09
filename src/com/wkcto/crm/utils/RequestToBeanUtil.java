package com.wkcto.crm.utils;

import org.apache.commons.beanutils.BeanUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;

public class RequestToBeanUtil {
    public static <T>T autoSet(HttpServletRequest request , Class<T> clazz)
    {
        //创建javaBean对象
        Object obj = null;
        try {
            obj = clazz.newInstance();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        //得到请求中的每个参数
        Enumeration<String> enu = request.getParameterNames();
        while(enu.hasMoreElements())
        {
            //获得参数名
            String name = enu.nextElement();
            //获得参数值
            String value = request.getParameter(name);
            //然后把参数拷贝到javaBean对象中
            try {
                BeanUtils.setProperty(obj, name, value);
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }
        }
        return (T)obj;
    }
}
