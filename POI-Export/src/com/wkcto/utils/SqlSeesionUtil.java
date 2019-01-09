package com.wkcto.utils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;


public class SqlSeesionUtil {
	private static SqlSessionFactory factory;
	private static ThreadLocal<SqlSession> t = new ThreadLocal<SqlSession>();
	static{
		try {
			factory = new SqlSessionFactoryBuilder()
					.build(Resources.getResourceAsStream("mybatis-config.xml"));
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
	
	public static SqlSession getCurrentSqlSession(){
		SqlSession sqlSession = t.get();
		if (sqlSession == null) {
			sqlSession = factory.openSession();
			t.set(sqlSession);
		}
		return sqlSession;
	}
	
	public static void close(SqlSession sqlSession){
		if (sqlSession != null) {
			sqlSession.close();
			t.remove();
		}
	}
	public static void rollBack(SqlSession sqlSession){
		if (sqlSession != null) {
			sqlSession.rollback();
		}
	}
}
