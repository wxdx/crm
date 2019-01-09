package com.wkcto.crm.utils;

import com.alibaba.fastjson.JSON;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class OutJson {
    private OutJson(){}
    public static void print(HttpServletRequest request, HttpServletResponse response,Object jsonMap){
        request.setAttribute("data", JSON.toJSONString(jsonMap));
        try {
            request.getRequestDispatcher("/data.jsp").forward(request,response);
        } catch (ServletException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
