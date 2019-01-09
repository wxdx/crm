package com.wkcto.crm.web;


import javax.servlet.*;
import java.io.IOException;

/**
 *
 */
public class CharacterEncodingFilter implements Filter {
    private String encoding;

    @Override
    public void init(FilterConfig filterConfig){
        this.encoding = filterConfig.getInitParameter("encoding");

    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        req.setCharacterEncoding(encoding);
        chain.doFilter(req, resp);
    }
}
