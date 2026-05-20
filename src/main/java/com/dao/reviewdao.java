package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.model.review;
import com.util.DBUtil;

public class reviewdao 
{
	Connection cn=null;
	public int userreview(review rmodel)
	{
		int x=0;
	cn=new DBUtil().getConnection();
	String qry="insert into review(name,rating,text) values(?,?,?)";
	 try {
		PreparedStatement st=cn.prepareStatement(qry);
	 } 
	 catch (Exception e)
	 {
		
		e.printStackTrace();
	}
	return x;
	}
}
