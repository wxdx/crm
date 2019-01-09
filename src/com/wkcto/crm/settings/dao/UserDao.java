package com.wkcto.crm.settings.dao;

import com.wkcto.crm.settings.domain.User;

public interface UserDao {
    int checkLoginAct(String loginAct);

    int save(User user);

    User getLoginActAndLoginPwd(String loginAct, String loginPwd);
}
