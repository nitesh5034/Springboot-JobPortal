package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.model.Postjob;
import com.model.UserModel;
import com.util.DBUtil;

public class userdao 
{
    Connection cn = null;

    /* ================= REGISTER ================= */
    public int userregistration(UserModel rmodel)
    {
        int x = 0;
        cn = new DBUtil().getConnection();
        String qry = "insert into userregister(firstname,lastname,email,mobileno,address,city,state,pincode,password,role) values(?,?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement st = cn.prepareStatement(qry);
            st.setString(1, rmodel.getFirstname());
            st.setString(2, rmodel.getLastname());
            st.setString(3, rmodel.getEmail());
            st.setString(4, rmodel.getContact());
            st.setString(5, rmodel.getAddress());
            st.setString(6, rmodel.getCity());
            st.setString(7, rmodel.getState());
            st.setInt(8, rmodel.getPincode());
            st.setString(9, rmodel.getPassword());
            st.setString(10, rmodel.getRole());

            System.out.println("Executing insert for user: " + rmodel.getFirstname() + ", " + rmodel.getEmail());
            x = st.executeUpdate();
            System.out.println("executeUpdate returned: " + x);

        } catch (SQLException e) {
            System.out.println("SQL Exception: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return x;
    }

    /* ================= LOGIN ================= */
    public UserModel UserLogin(UserModel lmodel)
    {
        UserModel Model = null;
        cn = new DBUtil().getConnection();
        String qry = "select * from userregister where email=? and password=?";

        try {
            PreparedStatement st = cn.prepareStatement(qry);
            st.setString(1, lmodel.getEmail());
            st.setString(2, lmodel.getPassword());
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Model = new UserModel();
                Model.setUserid(rs.getInt("userid"));
                Model.setFirstname(rs.getString("firstname"));
                Model.setLastname(rs.getString("lastname"));
                Model.setEmail(rs.getString("email"));
                Model.setContact(rs.getString("mobileno"));
                Model.setAddress(rs.getString("address"));
                Model.setCity(rs.getString("city"));
                Model.setState(rs.getString("state"));
                Model.setPincode(rs.getInt("pincode"));
                Model.setPassword(rs.getString("password"));
                Model.setRole(rs.getString("role"));
            }
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Model;
    }

    /* ================= UPDATE PROFILE ================= */
    public int updateUser(UserModel m) {
        int result = 0;
        try {
            cn = new DBUtil().getConnection();
            String sql = "UPDATE userregister SET firstname=?, lastname=?, mobileno=?, address=?, city=?, state=?, pincode=? WHERE userid=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, m.getFirstname());
            ps.setString(2, m.getLastname());
            ps.setString(3, m.getContact());
            ps.setString(4, m.getAddress());
            ps.setString(5, m.getCity());
            ps.setString(6, m.getState());
            ps.setInt(7, m.getPincode());
            ps.setInt(8, m.getUserid());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /* ================= GET USER BY EMAIL ================= */
    public UserModel getUserByEmail(String email) 
    {
        UserModel u = null;
        String sql = "SELECT * FROM userregister WHERE email=?";

        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                u = new UserModel();
                u.setUserid(rs.getInt("userid"));
                u.setEmail(rs.getString("email"));
                u.setFirstname(rs.getString("firstname"));
                u.setLastname(rs.getString("lastname"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return u;
    }

    /* ================= UPDATE PASSWORD ================= */
    public boolean updatePassword(String email, String newPassword) 
    {
        String sql = "UPDATE userregister SET password=? WHERE email=?";

        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public UserModel getUserById(int userid) {
        UserModel u = null;
        String sql = "SELECT * FROM userregister WHERE userid=?";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userid);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                u = new UserModel();
                u.setUserid(rs.getInt("userid"));
                u.setFirstname(rs.getString("firstname"));
                u.setLastname(rs.getString("lastname"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setIsVerified(rs.getInt("is_verified")); // ✅
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return u;
    }
    public boolean updateVerification(int userid, int status) {
        String sql = "UPDATE userregister SET is_verified=? WHERE userid=?";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, status);
            stmt.setInt(2, userid);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    /* ===== GET PENDING EMPLOYERS ===== */
    public List<UserModel> getPendingEmployers() {
        List<UserModel> list = new ArrayList<>();
        String sql = "SELECT * FROM userregister WHERE role='EMPLOYER' AND is_verified=0";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                UserModel u = new UserModel();
                u.setUserid(rs.getInt("userid"));
                u.setFirstname(rs.getString("firstname"));
                u.setLastname(rs.getString("lastname"));
                u.setEmail(rs.getString("email"));
                u.setContact(rs.getString("mobileno"));
                u.setCity(rs.getString("city"));
                u.setState(rs.getString("state"));
                u.setRole(rs.getString("role"));
                u.setIsVerified(rs.getInt("is_verified"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /* ===== GET TOTAL VERIFIED EMPLOYERS ===== */
    public int getTotalVerifiedEmployers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM userregister WHERE role='EMPLOYER' AND is_verified=1";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    /* ===== GET TOTAL ALL EMPLOYERS ===== */
    public int getTotalEmployers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM userregister WHERE role='EMPLOYER'";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    /* ===== USER APPLICATION STATS ===== */
    public int[] getUserApplicationStats(int userid) {
        int[] stats = {0, 0, 0}; // [total, selected, rejected, pending]
        String sql = "SELECT status, COUNT(*) as cnt FROM apply WHERE user_id=? GROUP BY status";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userid);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int cnt = rs.getInt("cnt");
                stats[0] += cnt; // total
                if ("selected".equalsIgnoreCase(status)) stats[1] = cnt;
                if ("rejected".equalsIgnoreCase(status)) stats[2] = cnt;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    /* ===== SAVE JOB ===== */
    public boolean saveJob(int userId, int jobId) {
        String sql = "INSERT IGNORE INTO saved_jobs(user_id, job_id) VALUES(?,?)";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, jobId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ===== REMOVE SAVED JOB ===== */
    public boolean removeSavedJob(int userId, int jobId) {
        String sql = "DELETE FROM saved_jobs WHERE user_id=? AND job_id=?";
        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, jobId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ===== GET SAVED JOBS ===== */
    public List<Postjob> getSavedJobs(int userId) {
        List<Postjob> list = new ArrayList<>();
        String sql = "SELECT p.* FROM `company job-update` p " +
                     "INNER JOIN saved_jobs s ON p.job_id = s.job_id " +
                     "WHERE s.user_id = ? " +
                     "ORDER BY s.saved_date DESC";

        try {
            Connection con = new DBUtil().getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Postjob job = new Postjob();
                job.setJob_id(rs.getInt("job_id"));
                job.setJob_Title(rs.getString("Job_Title"));        
                job.setCompany_name(rs.getString("company_name"));
                job.setLocation(rs.getString("Location"));          // ✅ Capital L
                job.setJob_Type(rs.getString("Job_Type"));          // ✅ Capital J T
                job.setSalary(rs.getString("salary"));
                job.setExperience(rs.getString("experience"));
                job.setOpening(rs.getInt("opening"));
                job.setJob_Description(rs.getString("Job_Description")); // ✅
                job.setSkills_req(rs.getString("skills_req"));
                job.setJob_Region(rs.getString("Job_Region"));      // ✅
                list.add(job);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean applyJob(int jobId, int userId) {
        boolean f = false;
        try {
           
            String sql = "insert into apply_job(job_id, user_id, status, date) values(?,?,?,?)";
            Connection con = new DBUtil().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, jobId);
            ps.setInt(2, userId);
            ps.setString(3, "pending");
            ps.setTimestamp(4, new java.sql.Timestamp(new java.util.Date().getTime()));

            int i = ps.executeUpdate();
            if (i == 1) f = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }
}