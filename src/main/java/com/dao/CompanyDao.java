package com.dao;

import com.model.companyverify;
import com.controller.UserController;
import com.model.Postjob;
import com.model.application;
import com.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDao {

    // =====================
    // DATABASE CONNECTION
    // =====================
    private Connection getConnection() throws Exception {
        return new DBUtil().getConnection();
    }

    // =====================
    // STATS METHODS
    // =====================

    public int getTotalCandidates() {
        int count = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM userregister");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getTotalApplications() {
        int count = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM apply");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /** Fetches count of verified (Approved) companies only */
    public int getTotalCompanies() {
        int count = 0;
        try {
            Connection con = getConnection();
            String sql = "SELECT COUNT(*) FROM company WHERE status = 'active'";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

  
    public int getAllRegisteredCompaniesCount() {
        int count = 0;
        try {
            Connection con = getConnection();
            String sql = "SELECT COUNT(*) FROM userregister WHERE role='EMPLOYER'";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // =====================
    // JOBS BY COMPANY
    // =====================

    public List<Postjob> getJobsByCompany(String email) {
        List<Postjob> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
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
                job.setAppliedCount(rs.getInt("appliedcount"));
                job.setEmail(rs.getString("Email"));
                list.add(job);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================
    // COMPANY REGISTER
    // =====================

    public boolean registerCompany(companyverify c) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO company (companyname, email, password, website, location, industry, companysize, about, status) VALUES (?,?,?,?,?,?,?,?,?)"
            );
            ps.setString(1, c.getCompanyname());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPassword());
            ps.setString(4, c.getWebsite());
            ps.setString(5, c.getLocation());
            ps.setString(6, c.getIndustry());
            ps.setString(7, c.getCompanysize());
            ps.setString(8, c.getAbout());
            ps.setString(9, "pending");
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =====================
    // COMPANY LOGIN
    // =====================

    public companyverify loginCompany(String email, String password) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM company WHERE email = ? AND password = ?"
            );
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                companyverify c = new companyverify();
                c.setCompany_id(rs.getInt("id"));
                c.setCompanyname(rs.getString("companyname"));
                c.setEmail(rs.getString("email"));
                c.setStatus(rs.getString("status"));
                con.close();
                return c;
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =====================
    // NOTIFICATION METHODS
    // =====================

    public void addNotification(String email, String message) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO notifications (email, message, is_read) VALUES (?, ?, 0)"
            );
            ps.setString(1, email);
            ps.setString(2, message);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<String> getUnreadNotifications(String email) {
        List<String> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT message FROM notifications WHERE email = ? AND is_read = 0"
            );
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("message"));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================
    // ADMIN METHODS
    // =====================

    public boolean updateCompanyStatus(int id, String status) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE company SET status = ? WHERE id = ?"
            );
            ps.setString(1, status);
            ps.setInt(2, id);
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<companyverify> getPendingCompanies() {
        List<companyverify> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM company WHERE status = 'pending'"
            );
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
            	companyverify c = new companyverify();
                c.setCompany_id(rs.getInt("id"));
                c.setCompanyname(rs.getString("companyname"));
                c.setEmail(rs.getString("email"));
                c.setWebsite(rs.getString("website"));
                c.setLocation(rs.getString("location"));
                c.setIndustry(rs.getString("industry"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    /* ===== PENDING COMPANIES ===== */
    public int getPendingCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM userregister WHERE role='EMPLOYER' AND is_verified=0";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    /* ===== REJECTED COMPANIES ===== */
    public int getRejectedCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM userregister WHERE role='EMPLOYER' AND is_verified=2";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }
    public List<companyverify> getAllCompaniesForAdmin() {
        List<companyverify> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM company ORDER BY id DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                companyverify c = new companyverify();
                c.setCompany_id(rs.getInt("id"));
                c.setCompanyname(rs.getString("companyname"));
                c.setEmail(rs.getString("email"));
                c.setWebsite(rs.getString("website"));
                c.setLocation(rs.getString("location"));
                c.setIndustry(rs.getString("industry"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<application> getApplicationsForCompany() {
        List<application> list = new ArrayList<>();
        try {
            
            Connection con = getConnection(); 
            
            String sql = "SELECT a.id, u.name, u.email, j.Job_Title, a.status, a.date " +
                         "FROM apply_job a " +
                         "JOIN userregister u ON a.user_id = u.id " + // ટેબલનું નામ ચેક કરજો
                         "JOIN `company job-update` j ON a.job_id = j.job_id ORDER BY a.id DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                application app = new application();
                app.setId(rs.getInt("id"));
                app.setUserName(rs.getString("name"));
                app.setUserEmail(rs.getString("email"));
                app.setJobTitle(rs.getString("Job_Title"));
                app.setStatus(rs.getString("status"));
                app.setApplyDate(rs.getString("date"));
                list.add(app);
            }
            con.close(); 
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}