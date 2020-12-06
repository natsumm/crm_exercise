package com.bjming.crm.settings.web.interceptor;

import com.bjming.crm.commons.contsants.MyConstants;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录验证的拦截器, 通过验证session中是否有user对象, 判断用户是否经过登录;
 * 2020/12/06 by AshenOne
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        Object user = request.getSession().getAttribute(MyConstants.SESSION_USER);
        if (user == null) {
            System.out.println("----拦截器拦截并跳转至-登录界面---");
            //session中没有user对象, 说明用户尚未经过登录, 重定向至登录首页(分属不同的业务, 使用重定向)
            response.sendRedirect(request.getContextPath());
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}


