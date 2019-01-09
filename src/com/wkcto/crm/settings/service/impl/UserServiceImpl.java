package com.wkcto.crm.settings.service.impl;

import com.wkcto.crm.exception.LoginException;
import com.wkcto.crm.settings.dao.UserDao;
import com.wkcto.crm.settings.domain.User;
import com.wkcto.crm.settings.service.UserService;
import com.wkcto.crm.utils.DateUtil;
import com.wkcto.crm.utils.SqlSeesionUtil;


public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSeesionUtil.getCurrentSqlSession().getMapper(UserDao.class);

    @Override
    public int checkLoginAct(String loginAct) {
        return userDao.checkLoginAct(loginAct);
    }

    @Override
    public int save(User user) {
        return userDao.save(user);
    }

    @Override
    public User login(String loginAct, String loginPwd, String clientIp) throws LoginException {
        User user = userDao.getLoginActAndLoginPwd(loginAct, loginPwd);
        //1.判断用户名密码是否正确
        if (user == null) {
            throw new LoginException("用户名密码错误");
        }
        //2.判断账户是否锁定
        if (user.getLockState() != null && !"".equals(user.getLockState())) {
            if ("1".equals(user.getLockState())) {
                throw new LoginException("账户已锁定,请联系管理员");
            }
        }
        //3.判断账户是否失效
        if (user.getExpireTime() != null && !"".equals(user.getExpireTime())) {
            if (DateUtil.getSysTime().compareTo(user.getExpireTime()) > 0) {
                throw new LoginException("账户已失效,请联系管理员");
            }
        }
        //4.判断登录IP是否限制
        if (user.getAllowIps() != null && !"".equals(user.getAllowIps())) {
            if (!user.getAllowIps().contains(clientIp)) {
                throw new LoginException("该账户ip地址受限,请联系管理员");
            }
        }
        return user;
    }
}
