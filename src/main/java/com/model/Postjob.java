package com.model;

import jakarta.persistence.*;

@Entity
@Table(name = "`company job-update`")
public class Postjob {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "job_id")
	private int jobId;

	@Column(name = "company_name")
	private String company_name;

	@Column(name = "email")
	private String email;

	@Column(name = "job_title")
	private String job_title;

	@Column(name = "job_region")
	private String job_region;

	@Column(name = "job_type")
	private String job_type;

	@Column(name = "salary")
	private String salary;

	@Column(name = "experience")
	private String experience;

	@Column(name = "opening")
	private int opening;

	@Column(name = "skills_req")
	private String skills_req;

	@Column(name = "job_description", length = 5000)
	private String job_description;

	@Column(name = "location")
	private String location;

	@Column(name = "applied_count")
	private int appliedCount;

	// Default Constructor
	public Postjob() {}

	// Primary Getters and Setters
	public int getJobId() {
		return jobId;
	}

	public void setJobId(int jobId) {
		this.jobId = jobId;
	}

	public String getCompany_name() {
		return company_name;
	}

	public void setCompany_name(String company_name) {
		this.company_name = company_name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getJob_title() {
		return job_title;
	}

	public void setJob_title(String job_title) {
		this.job_title = job_title;
	}

	public String getJob_region() {
		return job_region;
	}

	public void setJob_region(String job_region) {
		this.job_region = job_region;
	}

	public String getJob_type() {
		return job_type;
	}

	public void setJob_type(String job_type) {
		this.job_type = job_type;
	}

	public String getSalary() {
		return salary;
	}

	public void setSalary(String salary) {
		this.salary = salary;
	}

	public String getExperience() {
		return experience;
	}

	public void setExperience(String experience) {
		this.experience = experience;
	}

	public int getOpening() {
		return opening;
	}

	public void setOpening(int opening) {
		this.opening = opening;
	}

	public String getSkills_req() {
		return skills_req;
	}

	public void setSkills_req(String skills_req) {
		this.skills_req = skills_req;
	}

	public String getJob_description() {
		return job_description;
	}

	public void setJob_description(String job_description) {
		this.job_description = job_description;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getAppliedCount() {
		return appliedCount;
	}

	public void setAppliedCount(int appliedCount) {
		this.appliedCount = appliedCount;
	}

	// =======================================================
	// ALIAS GETTERS & SETTERS (Prevents JSP Compilation Errors)
	// =======================================================

	// Job Title Aliases
	public String getJob_Title() { return job_title; }
	public void setJob_Title(String job_Title) { this.job_title = job_Title; }
	public String getJobTitle() { return job_title; }
	public void setJobTitle(String jobTitle) { this.job_title = jobTitle; }

	// Job Type Aliases
	public String getJob_Type() { return job_type; }
	public void setJob_Type(String job_Type) { this.job_type = job_Type; }
	public String getJobType() { return job_type; }
	public void setJobType(String jobType) { this.job_type = jobType; }

	// Job Region Aliases
	public String getJob_Region() { return job_region; }
	public void setJob_Region(String job_Region) { this.job_region = job_Region; }
	public String getJobRegion() { return job_region; }
	public void setJobRegion(String jobRegion) { this.job_region = jobRegion; }

	// Job Description Aliases
	public String getJob_Description() { return job_description; }
	public void setJob_Description(String job_Description) { this.job_description = job_Description; }
	public String getJobDescription() { return job_description; }
	public void setJobDescription(String jobDescription) { this.job_description = jobDescription; }

	// Skills Aliases
	public String getSkillsReq() { return skills_req; }
	public void setSkillsReq(String skillsReq) { this.skills_req = skillsReq; }
}