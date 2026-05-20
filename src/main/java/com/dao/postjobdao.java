package com.dao;

import java.sql.*;
import java.util.List;

import com.model.Postjob;
import com.util.DBUtil;

public class postjobdao {
    public int saveJob(Postjob job) {
        int status = 0;
        String sql = "INSERT INTO `company job-update`(email, job_Title,opening, Location,experience,skills_req,job_Region, job_Type, job_Description,salary,company_name) VALUES ( ?, ?, ?, ?, ?, ?,?,?,?,?,?)";
        
        try (Connection cn = new DBUtil().getConnection()) {
            
            if (cn == null) {
                System.out.println("Error: Database connection failed!");
                return 0;
            }

            PreparedStatement ps = cn.prepareStatement(sql);
           
            ps.setString(1, job.getEmail());
            ps.setString(2, job.getJob_Title());
            ps.setInt(3, job.getOpening());
            ps.setString(4, job.getLocation());
            ps.setString(5,job.getExperience());
            ps.setString(6, job.getSkills_req());
            ps.setString(7, job.getJob_Region());
            ps.setString(8, job.getJob_Type());
            ps.setString(9, job.getJob_Description());
            ps.setString(10, job.getSalary());
            ps.setString(11, job.getCompany_name());
            
            status = ps.executeUpdate();
            
            if (status > 0) {
                System.out.println(" Job Saved Successfully in Database!");
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace(); 
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
        return status;
    }
    public int getTotalJobs() {
        int count = 0;
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM `company job-update`");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close(); ps.close(); cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Postjob> getJobsByCompany(String email) {
        List<Postjob> list = new java.util.ArrayList<>();
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement(
                "SELECT * FROM `company job-update` WHERE Email = ? ORDER BY job_id DESC"
            );
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Postjob job = new Postjob();
                job.setJob_id(rs.getInt("job_id"));
                job.setJob_Title(rs.getString("Job_Title"));
                job.setJob_Type(rs.getString("Job_Type"));
                job.setLocation(rs.getString("Location"));
                job.setSalary(rs.getString("salary"));
                job.setOpening(rs.getInt("opening"));
                job.setExperience(rs.getString("experience"));
                job.setSkills_req(rs.getString("skills_req"));
                job.setAppliedCount(rs.getInt("applied_count"));
                job.setEmail(rs.getString("Email"));
                list.add(job);
            }
            rs.close(); ps.close(); cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Postjob> getAllJobs() {
        List<Postjob> list = new java.util.ArrayList<>();
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement(
                "SELECT * FROM `company job-update` ORDER BY job_id DESC"
            );
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Postjob job = new Postjob();
                job.setJob_id(rs.getInt("job_id"));
                job.setJob_Title(rs.getString("Job_Title"));
                job.setJob_Type(rs.getString("Job_Type"));
                job.setLocation(rs.getString("Location"));
                job.setSalary(rs.getString("salary"));
                job.setOpening(rs.getInt("opening"));
                job.setExperience(rs.getString("experience"));
                job.setSkills_req(rs.getString("skills_req"));
                job.setJob_Description(rs.getString("Job_Description"));
                job.setJob_Region(rs.getString("Job_Region"));
                job.setCompany_name(rs.getString("company_name"));
                job.setEmail(rs.getString("Email"));
                list.add(job);
            }
            rs.close(); ps.close(); cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}