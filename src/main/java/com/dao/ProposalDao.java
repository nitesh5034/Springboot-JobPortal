package com.dao;

import com.model.Proposal;
import com.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProposalDao {

    public int createProposal(Proposal p) {
        int result = 0;
        try {
            Connection cn = new DBUtil().getConnection();
            String sql = "INSERT INTO proposals (companyname, companyemail, proposaltitle, proposaldesc, terms, dealamount, status) VALUES (?,?,?,?,?,?,'pending')";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, p.getCompanyName());
            ps.setString(2, p.getCompanyEmail());
            ps.setString(3, p.getProposalTitle());
            ps.setString(4, p.getProposalDesc());
            ps.setString(5, p.getTerms());
            ps.setString(6, p.getDealAmount());
            result = ps.executeUpdate();
            ps.close(); cn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    public List<Proposal> getAllProposals() {
        List<Proposal> list = new ArrayList<>();
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("SELECT * FROM proposals ORDER BY createddate DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Proposal p = new Proposal();
                p.setProposalId(rs.getInt("proposalid"));
                p.setCompanyName(rs.getString("companyname"));
                p.setCompanyEmail(rs.getString("companyemail"));
                p.setProposalTitle(rs.getString("proposaltitle"));
                p.setProposalDesc(rs.getString("proposaldesc"));
                p.setTerms(rs.getString("terms"));
                p.setDealAmount(rs.getString("dealamount"));
                p.setStatus(rs.getString("status"));
                p.setCreatedDate(rs.getString("createddate"));
                list.add(p);
            }
            rs.close(); ps.close(); cn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int updateStatus(int proposalId, String status) {
        int result = 0;
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("UPDATE proposals SET status=? WHERE proposalid=?");
            ps.setString(1, status);
            ps.setInt(2, proposalId);
            result = ps.executeUpdate();
            ps.close(); cn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    public int deleteProposal(int proposalId) {
        int result = 0;
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("DELETE FROM proposals WHERE proposalid=?");
            ps.setInt(1, proposalId);
            result = ps.executeUpdate();
            ps.close(); cn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }
}