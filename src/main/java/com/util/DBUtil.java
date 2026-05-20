package com.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil 
{
	Connection cn=null;
	public  Connection getConnection()
	{
		try 
		{
			Class.forName("com.mysql.jdbc.Driver");
			cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal","root","");
			System.out.println("connection established");
		
		if(cn!=null)
		{
			System.out.println("connection is successfully");
		}
	}
		catch (Exception e) 
		{
			System.out.println("db connection error");
			e.printStackTrace();
		}
		if(cn==null)
		{
			System.out.println("connetion is null");
		}
		return cn;
	}
}
