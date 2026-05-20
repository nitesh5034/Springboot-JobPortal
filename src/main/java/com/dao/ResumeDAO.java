package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.model.resumemodel;
import com.util.DBUtil;

public class ResumeDAO {

    
    public void saveResume(resumemodel resume) {
        String sql = "INSERT INTO resumes(file_name, file_path) VALUES (?, ?)";
        
       
        try (Connection cn = new DBUtil().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            if (cn == null) {
                System.out.println("Error: Database connection is null!");
                return;
            }

           
            System.out.println("Inserting File: " + resume.getFilename());
            System.out.println("Inserting Path: " + resume.getFilepath());

            ps.setString(1, resume.getFilename());
            ps.setString(2, resume.getFilepath());
            
            int result = ps.executeUpdate(); 
            
            if (result > 0) {
                System.out.println("Data Inserted Successfully into Database!");
            } else {
                System.out.println("Data NOT Inserted. Check Table structure.");
            }
            
        } catch (Exception e) {
            System.err.println("DAO Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}