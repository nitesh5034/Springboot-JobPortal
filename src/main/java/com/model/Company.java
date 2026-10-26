package com.model;

import jakarta.persistence.*;

@Entity
@Table(name = "company")
public class Company {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String companyname;
    private String email;
    private String location;
    private String website;

    @Column(columnDefinition = "TEXT")
    private String about;

    private String status; // 'pending', 'active', 'inactive'

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCompanyname() { return companyname; }
    public void setCompanyname(String companyname) { this.companyname = companyname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }

    public String getAbout() { return about; }
    public void setAbout(String about) { this.about = about; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}