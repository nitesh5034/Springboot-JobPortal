package com.util;

import java.sql.Connection;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DBUtil 
{
	private static DataSource dataSource;

	@Autowired
	public void setDataSource(DataSource ds) {
		DBUtil.dataSource = ds;
	}

	public Connection getConnection()
	{
		try 
		{
			Connection cn = dataSource.getConnection();
			if(cn != null) {
				System.out.println("connection is successfully established from pool");
			}
			return cn;
		}
		catch (Exception e) 
		{
			System.out.println("db connection error");
			e.printStackTrace();
			return null;
		}
	}
}
