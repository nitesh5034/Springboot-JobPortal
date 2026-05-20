package com.model;

public class Postjob 
{
	private int opening,job_id;
	private int appliedCount;

	
	

	public int getAppliedCount() {
		return appliedCount;
	}

	public void setAppliedCount(int appliedCount) {
		this.appliedCount = appliedCount;
	}

	private String experience;
	
	public int getJob_id() {
		return job_id;
	}

	public void setJob_id(int job_id) {
		this.job_id = job_id;
	}

	private String email,job_Title,Location,skills_req,job_Region,job_Type,job_Description,salary,company_name;

	public String getExperience() {
		return experience;
	}

	public void setExperience(String experience) {
		this.experience = experience;
	}

	public String getSkills_req() {
		return skills_req;
	}

	public void setSkills_req(String skills_req) {
		this.skills_req = skills_req;
	}

	public String getSalary() {
		return salary;
	}

	public void setSalary(String salary) {
		this.salary = salary;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getJob_Title() {
		return job_Title;
	}

	public void setJob_Title(String job_Title) {
		this.job_Title = job_Title;
	}

	public int getOpening() {
		return opening;
	}

	public void setOpening(int opening) {
		this.opening = opening;
	}

	public String getLocation() {
		return Location;
	}

	public void setLocation(String location) {
		Location = location;
	}

	public String getJob_Region() {
		return job_Region;
	}

	public void setJob_Region(String job_Region) {
		this.job_Region = job_Region;
	}

	public String getJob_Type() {
		return job_Type;
	}

	public void setJob_Type(String job_Type) {
		this.job_Type = job_Type;
	}

	public String getJob_Description() {
		return job_Description;
	}

	public void setJob_Description(String job_Description) {
		this.job_Description = job_Description;
	}
	public String getCompany_name() {
		return company_name;
	}

	public void setCompany_name(String company_name) {
		this.company_name = company_name;
	}

}
