package com.model;
public class Proposal {
    private int proposalId;
    private String companyname, companyemail, proposaltitle, proposaldesc, terms, dealamount, status, createddate;
	public int getProposalId() {
		return proposalId;
	}
	public void setProposalId(int proposalId) {
		this.proposalId = proposalId;
	}
	public String getCompanyName() {
		return companyname;
	}
	public void setCompanyName(String companyName) {
		this.companyname = companyName;
	}
	public String getCompanyEmail() {
		return companyemail;
	}
	public void setCompanyEmail(String companyEmail) {
		this.companyemail = companyEmail;
	}
	public String getProposalTitle() {
		return proposaltitle;
	}
	public void setProposalTitle(String proposalTitle) {
		this.proposaltitle = proposalTitle;
	}
	public String getProposalDesc() {
		return proposaldesc;
	}
	public void setProposalDesc(String proposalDesc) {
		this.proposaldesc = proposalDesc;
	}
	public String getTerms() {
		return terms;
	}
	public void setTerms(String terms) {
		this.terms = terms;
	}
	public String getDealAmount() {
		return dealamount;
	}
	public void setDealAmount(String dealAmount) {
		this.dealamount = dealAmount;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCreatedDate() {
		return createddate;
	}
	public void setCreatedDate(String createdDate) {
		this.createddate = createdDate;
	}


}