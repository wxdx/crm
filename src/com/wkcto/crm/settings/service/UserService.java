package com.wkcto.crm.settings.service;

import com.wkcto.crm.exception.LoginException;
import com.wkcto.crm.settings.domain.User;

public interface UserService {
    int checkLoginAct(String loginAct);

    int save(User user);

    User login(String loginAct, String loginPwd, String clientIp) throws LoginException;
}
