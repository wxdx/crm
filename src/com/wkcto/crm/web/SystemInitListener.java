package com.wkcto.crm.web;


import com.wkcto.crm.settings.domain.DicValue;
import com.wkcto.crm.settings.service.DicValueService;
import com.wkcto.crm.settings.service.impl.DicValueServiceImpl;
import com.wkcto.crm.utils.TransactionInvocationHandler;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SystemInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        /*
         * Map<String,List<DicValue>>
         * key                 value
         * ---------------------------------
         * "appellation"          appllationList
         * ......
         *
         */
        ServletContext application = sce.getServletContext();
        DicValueService dicValueService = (DicValueService) new TransactionInvocationHandler(new DicValueServiceImpl()).getProxy();

        Map<String, List<DicValue>> dicValueMap = dicValueService.getAll();

        /*Set<String> keys = dicValueMap.keySet();
        for (String key:keys){
            application.setAttribute(key,dicValueMap.get(key));
        }*/
        Set<Map.Entry<String, List<DicValue>>> entrySet = dicValueMap.entrySet();
        for (Map.Entry<String, List<DicValue>> set:entrySet){
            application.setAttribute(set.getKey(),set.getValue());
        }

        ResourceBundle bundle = ResourceBundle.getBundle("com.wkcto.crm.resource.stage2possibility");
        Enumeration<String> keys1 = bundle.getKeys();
        Map<String,String> possibilityMap = new HashMap<>();
        while (keys1.hasMoreElements()){
            String key = keys1.nextElement();
            String value = bundle.getString(key);
            possibilityMap.put(key,value);
        }
        application.setAttribute("possibilityMap",possibilityMap);
    }
}
