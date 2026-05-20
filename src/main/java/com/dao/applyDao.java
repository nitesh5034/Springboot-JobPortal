package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.model.applymodel;
import com.util.DBUtil;

public class applyDao {

    Connection cn = null;

    /* ================= APPLY JOB ================= */
    public int apply(applymodel model) {
        int status = 0;
        cn = new DBUtil().getConnection();
      
        String qry = "INSERT INTO apply(job_id, fullname, email, mobileno, city, experience, resume, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            if (cn != null) {
                PreparedStatement st = cn.prepareStatement(qry);
                st.setInt(1, model.getJob_id()); 
                
                st.setString(2, model.getFullname());
                st.setString(3, model.getEmail());
                st.setString(4, model.getMobileno());
                st.setString(5, model.getCity());
                st.setString(6, model.getExperience());
                st.setString(7, model.getResume());
                st.setString(8, model.getStatus()); 

                status = st.executeUpdate();
                
                if(status > 0) {
                    System.out.println("DAO: Application inserted successfully for Job ID: " + model.getJob_id());
                }
            }
        } catch (SQLException e) 
        {
            System.err.println("DAO SQL ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally 
        {
            try 
            {
            	if (cn != null) 
            	cn.close(); 
            	} 
            catch (SQLException e) 
            { 
            	e.printStackTrace(); 
            	}
        }
        return status;
    }

    /* ================= GET APPLICATIONS BY JOB ID ================= */
    public List<applymodel> getApplicationsByJobId(int jobId) {
        List<applymodel> list = new ArrayList<>();
        String sql = "SELECT * FROM apply WHERE job_id=? ORDER BY app_id DESC";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, jobId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                applymodel a = new applymodel();
                a.setApp_id(rs.getInt("app_id")); 
                a.setJob_id(rs.getInt("job_id"));
                a.setFullname(rs.getString("fullname"));
                a.setEmail(rs.getString("email"));
                a.setMobileno(rs.getString("mobileno"));
                a.setCity(rs.getString("city"));
                a.setExperience(rs.getString("experience"));
                a.setResume(rs.getString("resume"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ================= GET APPLICATIONS BY COMPANY EMAIL ================= */
    public List<applymodel> getApplicationsByEmail(String companyEmail) {
        List<applymodel> list = new ArrayList<>();
        String sql = "SELECT a.* FROM apply a " +
                     "INNER JOIN `company job-update` j ON a.job_id = j.job_id " +
                     "WHERE j.Email=? ORDER BY a.app_id DESC";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, companyEmail);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                applymodel a = new applymodel();
                a.setApp_id(rs.getInt("app_id")); 
                a.setJob_id(rs.getInt("job_id"));
                a.setFullname(rs.getString("fullname"));
                a.setEmail(rs.getString("email"));
                a.setMobileno(rs.getString("mobileno"));
                a.setCity(rs.getString("city"));
                a.setExperience(rs.getString("experience"));
                a.setResume(rs.getString("resume"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ================= UPDATE STATUS ================= */
    public boolean updateStatus(int applyId, String status) {
        String sql = "UPDATE apply SET status=? WHERE app_id=?";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, applyId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
    }
    public applymodel getApplicationById(int id) {
        applymodel amodel = null;
        try {
            
            Connection con = new DBUtil().getConnection(); 
          
            String query = "SELECT * FROM apply WHERE app_id=?"; 
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                amodel = new applymodel();
                amodel.setApp_id(rs.getInt("app_id"));
                amodel.setFullname(rs.getString("fullname"));
                amodel.setEmail(rs.getString("email"));
                amodel.setJob_id(rs.getInt("job_id")); 
                amodel.setStatus(rs.getString("status"));
            }
        } catch (Exception e) {
            System.out.println("Error in getApplicationById: " + e.getMessage());
            e.printStackTrace();
        }
        return amodel;
    }
    /* ================= GET ALL APPLICATIONS FOR A CANDIDATE ================= */
    public List<applymodel> getApplicationsByUserEmail(String userEmail) {
        List<applymodel> list = new ArrayList<>();
        String sql = "SELECT * FROM apply WHERE email=? ORDER BY app_id DESC";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, userEmail);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                applymodel a = new applymodel();
                a.setApp_id(rs.getInt("app_id")); 
                a.setJob_id(rs.getInt("job_id"));
                a.setFullname(rs.getString("fullname"));
                a.setEmail(rs.getString("email"));
                a.setMobileno(rs.getString("mobileno"));
                a.setCity(rs.getString("city"));
                a.setExperience(rs.getString("experience"));
                a.setResume(rs.getString("resume"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
}