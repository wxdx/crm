package com.wkcto.crm.workbench.controller;

import com.wkcto.crm.utils.OutJson;
import com.wkcto.crm.utils.TransactionInvocationHandler;
import com.wkcto.crm.workbench.service.ChartService;
import com.wkcto.crm.workbench.service.impl.ChartServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 图表控制器
 */
public class ChartController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        String path = request.getServletPath();

        if ("/workbench/chart/tran.do".equals(path)) {
            doShowTranChart(request, response);
        }

    }

    protected void doShowTranChart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ChartService chartService = (ChartService) new TransactionInvocationHandler(new ChartServiceImpl()).getProxy();
        List<Map<String, Object>> dataList = chartService.getTranChart();
        OutJson.print(request, response, dataList);
    }
}
