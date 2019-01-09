package com.wkcto.crm.utils;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.apache.ibatis.session.SqlSession;



public class TransactionInvocationHandler implements InvocationHandler {
	private Object taget;
	
	
	public TransactionInvocationHandler(Object taget) {
		super();
		this.taget = taget;
	}
	@Override
	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		SqlSession sqlSession = null;
		Object obj = null;
		try{
			sqlSession = SqlSeesionUtil.getCurrentSqlSession();

			//真正执行的service方法
			obj = method.invoke(taget, args);
			
			sqlSession.commit();
		}catch (Exception e) {
			sqlSession.rollback();
			e.printStackTrace();
			//继续往上抛
			throw e.getCause(); //获取到根异常
		}finally{
			SqlSeesionUtil.close(sqlSession);
		}
		return obj;
	}
	
	public Object getProxy(){
		return Proxy.newProxyInstance(taget.getClass().getClassLoader(), taget.getClass().getInterfaces(), this);
	}

}
