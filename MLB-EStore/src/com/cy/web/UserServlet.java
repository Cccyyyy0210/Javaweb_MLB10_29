package com.cy.web;

import com.cy.domain.User;
import com.cy.service.UserService;
import com.cy.service.impl.UserServiceImpl;
import com.cy.utils.WebUtils;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import static com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY;

@WebServlet("/userServlet")
public class UserServlet extends BaseServlet{
    public UserService userService = new UserServiceImpl();

    //注销功能
    protected void logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().invalidate();
        resp.sendRedirect(req.getContextPath());
    }

    //查询用户名是否可用
    protected void ajaxExistsUsername(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, SQLException {
        String username = req.getParameter("username");
        boolean exitsUsername = userService.existsUsername(username);
        Map<String, Object> resultMap = new HashMap<String, Object>();

        resultMap.put("exitsUsername", exitsUsername);

        Gson gson = new Gson();
        String json = gson.toJson(resultMap);

        resp.getWriter().write(json);
    }

    //登录功能
    protected void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, SQLException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        User loginUser = userService.login(new User(null, username, password, null));
        //用户名或密码错误
        if (loginUser == null) {
            req.setAttribute("msg", "用户名或密码错误！");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/pages/user/login.jsp").forward(req, resp);
        } else {
            //将成功登录的用户信息保存到session域
            req.getSession().setAttribute("user", loginUser);
            req.getRequestDispatcher("/pages/user/login_success.jsp").forward(req, resp);
        }
    }

    //注册功能
    protected void regist(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, SQLException {
        //1.获取请求参数
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String repwd = req.getParameter("repwd");
        String email = req.getParameter("email");
        String code = req.getParameter("code");
        User user = WebUtils.copyParamToBean(req.getParameterMap(), new User());

        String token = (String) req.getSession().getAttribute(KAPTCHA_SESSION_KEY);

        //2.检查验证码是否正确
        if (token != null && token.equalsIgnoreCase(code)) {
            if (userService.existsUsername(username)) {
                req.setAttribute("msg", "用户名不可用");
                req.setAttribute("username", username);
                req.setAttribute("email", email);
                req.setAttribute("password", password);
                req.setAttribute("repwd", repwd);
                req.setAttribute("code", code);
//                System.out.println("用户名[" + username + "]不可用");
                req.getRequestDispatcher("/pages/user/regist.jsp").forward(req, resp);
            } else {
                userService.registUser(user);
                req.getRequestDispatcher("/pages/user/regist_success.jsp").forward(req, resp);
            }

        } else {
            req.setAttribute("msg", "验证码错误");
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.setAttribute("password", password);
            req.setAttribute("repwd", repwd);
            req.setAttribute("code", code);
//            System.out.println("验证码[" + code + "]错误！");
            req.getRequestDispatcher("/pages/user/regist.jsp").forward(req, resp);
        }
    }

}
