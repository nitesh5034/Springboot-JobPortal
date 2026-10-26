package com.model;

import jakarta.persistence.*;

@Entity
@Table(name = "applymodel")
public class applymodel {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "app_id")
	private int app_id;

	@Column(name = "job_id")
	private int jobId;

	@Column(name = "fullname")
	private String fullname;

	@Column(name = "email")
	private String email;

	@Column(name = "mobileno")
	private String mobileno;

	@Column(name = "city")
	private String city;

	@Column(name = "experience")
	private String experience;

	@Column(name = "resume")
	private String resume;

	@Column(name = "status")
	private String status;

	// Default Constructor
	public applymodel() {}

	// Primary Getters and Setters
	public int getApp_id() {
		return app_id;
	}

	public void setApp_id(int app_id) {
		this.app_id = app_id;
	}

	public int getJobId() {
		return jobId;
	}

	public void setJobId(int jobId) {
		this.jobId = jobId;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMobileno() {
		return mobileno;
	}

	public void setMobileno(String mobileno) {
		this.mobileno = mobileno;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getExperience() {
		return experience;
	}

	public void setExperience(String experience) {
		this.experience = experience;
	}

	public String getResume() {
		return resume;
	}

	public void setResume(String resume) {
		this.resume = resume;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	// =======================================================
	// ALIAS GETTERS & SETTERS (Prevents JSP Compilation Errors)
	// =======================================================

	public int getJob_id() {
		return this.jobId;
	}

	public void setJob_id(int job_id) {
		this.jobId = job_id;
	}

	public int getAppId() {
		return this.app_id;
	}

	public void setAppId(int appId) {
		this.app_id = appId;
	}
}