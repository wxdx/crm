package com.wkcto.crm.web;


import com.wkcto.crm.utils.Const;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getServletPath();

        if ("/login.do".equals(path) || "/login.jsp".equals(path) || "/welcome.do".equals(path)){
            chain.doFilter(request,response);
        } else {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute(Const.Session_User) != null){
                chain.doFilter(request,response);
            } else {
                response.sendRedirect(request.getContextPath() + "/welcome.do");
            }
        }


    }
}
