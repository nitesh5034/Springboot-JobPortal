package com.controller;

import jakarta.servlet.http.HttpServletRequest; // ➕ ADDED FOR SERVLET CONTEXT
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Repository.UserRepository;
import com.Repository.CompanyVerifyRepository;
import com.Repository.CompanyRepository;
import com.model.UserModel;
import com.model.companyverify;
import com.model.Company;

import java.io.File;
import java.util.Optional;

@Controller
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CompanyVerifyRepository companyVerifyRepository;

    @Autowired
    private CompanyRepository companyRepository;

    @GetMapping("/UserController")
    public String doGet() {
        return "redirect:/index.jsp";
    }

    /* ================= LOGOUT ENDPOINT ================= */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate(); // Clear active session
        }
        return "redirect:/login.jsp?msg=logout";
    }

    @PostMapping("/UserController")
    public String doPost(
            HttpSession session,
            HttpServletRequest request, // ➕ ADDED HttpServletRequest PARAMETER
            @RequestParam(value = "action", required = false) String action,
            @RequestParam(value = "fname", required = false) String fname,
            @RequestParam(value = "lname", required = false) String lname,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "contact", required = false) String contact,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "pincode", required = false, defaultValue = "0") String pincodeStr,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam(value = "role", required = false) String role,
            @RequestParam(value = "userid", required = false) String userIdStr,
            @RequestParam(value = "website", required = false) String website,
            @RequestParam(value = "about", required = false) String about,
            @RequestParam(value = "profilePic", required = false) MultipartFile profilePic
    ) {
        System.out.println("Action Received: " + action);

        if (action == null) {
            return "redirect:/index.jsp";
        }

        /* ================= REGISTER LOGIC ================= */
        if ("register".equalsIgnoreCase(action)) {

            UserModel rmodel = new UserModel();
            rmodel.setFirstname(fname);
            rmodel.setLastname(lname);
            rmodel.setEmail(email);
            rmodel.setContact(contact);
            rmodel.setAddress(address);
            rmodel.setCity(city);
            rmodel.setState(state);

            try {
                rmodel.setPincode(Integer.parseInt(pincodeStr));
            } catch (NumberFormatException e) {
                rmodel.setPincode(0);
            }

            rmodel.setPassword(password);
            rmodel.setRole(role);

            // Set verification status according to role
            if ("EMPLOYER".equalsIgnoreCase(rmodel.getRole())) {
                rmodel.setIsVerified(0); // 0 = Pending Approval
            } else {
                rmodel.setIsVerified(1); // JOBSEEKER is auto verified
            }

            UserModel savedUser = userRepository.save(rmodel);

            if (savedUser != null) {
                if ("EMPLOYER".equalsIgnoreCase(rmodel.getRole())) {

                    // SAVE TO 'company' TABLE FOR ADMIN DASHBOARD DISPLAY
                    try {
                        Company comp = new Company();
                        comp.setCompanyname(fname + (lname != null ? " " + lname : ""));
                        comp.setEmail(email);
                        comp.setLocation(city != null ? city : address);
                        comp.setWebsite(website != null ? website : "");
                        comp.setAbout(about != null ? about : "Company Registered via JobBoard");
                        comp.setStatus("pending");

                        companyRepository.save(comp);
                    } catch (Exception e) {
                        System.err.println("Error saving company entry: " + e.getMessage());
                    }

                    return "redirect:/verfi.jsp?status=pending";
                } else {
                    return "redirect:/login.jsp?msg=registered";
                }
            } else {
                return "redirect:/registration.jsp?msg=failed";
            }
        }

        /* ================= LOGIN LOGIC ================= */
        else if ("login".equalsIgnoreCase(action)) {

            Optional<UserModel> userOpt = userRepository.findFirstByEmailAndPassword(email, password);

            if (userOpt.isPresent()) {
                UserModel model = userOpt.get();
                session.setAttribute("Model", model);
                session.setAttribute("role", model.getRole());

                // Role-based Navigation
                if ("JOBSEEKER".equalsIgnoreCase(model.getRole())) {
                    return "redirect:/user-home.jsp";
                }
                else if ("EMPLOYER".equalsIgnoreCase(model.getRole())) {
                    if (model.getIsVerified() == 1) {
                        return "redirect:/compny-home.jsp";
                    } else {
                        return "redirect:/verfi.jsp?status=pending";
                    }
                }
                else if ("ADMIN".equalsIgnoreCase(model.getRole())) {
                    return "redirect:/admin-home.jsp";
                }
                else {
                    return "redirect:/user-home.jsp";
                }
            }

            // Check CompanyVerify Table
            Optional<companyverify> compOpt = companyVerifyRepository.findFirstByEmailAndPassword(email, password);

            if (compOpt.isPresent()) {
                companyverify compModel = compOpt.get();
                session.setAttribute("Model", compModel);
                session.setAttribute("role", "EMPLOYER");
                session.setAttribute("companyname", compModel.getCompanyname());
                String status = compModel.getStatus();

                if ("pending".equalsIgnoreCase(status)) {
                    return "redirect:/verfi.jsp?status=pending";
                } else if ("rejected".equalsIgnoreCase(status)) {
                    return "redirect:/verfi.jsp?status=rejected";
                } else {
                    return "redirect:/compny-home.jsp";
                }
            }

            return "redirect:/login.jsp?msg=error";
        }

        /* ================= UPDATE PROFILE LOGIC ================= */
        else if ("updateProfile".equalsIgnoreCase(action)) {

            try {
                int userId = Integer.parseInt(userIdStr);
                Optional<UserModel> existingUserOpt = userRepository.findById(userId);

                if (existingUserOpt.isPresent()) {
                    UserModel umodel = existingUserOpt.get();
                    umodel.setFirstname(fname);
                    umodel.setLastname(lname);
                    umodel.setEmail(email);
                    umodel.setContact(contact);
                    umodel.setAddress(address);
                    umodel.setCity(city);
                    umodel.setState(state);
                    umodel.setPincode(Integer.parseInt(pincodeStr));

                    userRepository.save(umodel);

                    session.setAttribute("Model", umodel);
                    return "redirect:/ViewProfile.jsp?msg=updated";
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            return "redirect:/edit-profile.jsp?msg=failed";


        }
        /* ================= DELETE ACCOUNT PERMANENTLY LOGIC ================= */
        else if ("deleteAccount".equalsIgnoreCase(action)) {

            UserModel sessionUser = (UserModel) session.getAttribute("Model");

            if (sessionUser != null) {
                try {
                    int userId = sessionUser.getUserid();

                    // 1. Database se permanently delete karein
                    userRepository.deleteById(userId);

                    // 2. Active Session invalidate / clear karein
                    session.invalidate();

                    // 3. Login page par redirect karein success message ke sath
                    return "redirect:/login.jsp?msg=accountDeleted";

                } catch (Exception e) {
                    e.printStackTrace();
                    return "redirect:/ViewProfile.jsp?msg=error";
                }
            }
            return "redirect:/login.jsp";
        }

        /* ================= UPDATE PROFILE PICTURE LOGIC ================= */
        else if ("updateProfilePic".equalsIgnoreCase(action)) {

            UserModel sessionUser = (UserModel) session.getAttribute("Model");

            if (sessionUser != null) {
                try {
                    if (profilePic != null && !profilePic.isEmpty()) {

                        // Target webapp uploads directory
                        String uploadDir = request.getServletContext().getRealPath("/uploads");
                        File dir = new File(uploadDir);
                        if (!dir.exists()) {
                            dir.mkdirs();
                        }

                        String fileName = System.currentTimeMillis() + "_" + profilePic.getOriginalFilename();
                        File serverFile = new File(dir.getAbsolutePath() + File.separator + fileName);
                        profilePic.transferTo(serverFile);

                        // Save image filename in DB & update Session
                        Optional<UserModel> userOpt = userRepository.findById(sessionUser.getUserid());
                        if (userOpt.isPresent()) {
                            UserModel umodel = userOpt.get();

                            try {
                                java.lang.reflect.Method setPicMethod = umodel.getClass().getMethod("setProfilePic", String.class);
                                setPicMethod.invoke(umodel, fileName);
                            } catch (Exception ex) {
                                System.out.println("Note: profilePic method reflection handling");
                            }

                            userRepository.save(umodel);
                            session.setAttribute("Model", umodel);
                        }
                    }
                    return "redirect:/ViewProfile.jsp?msg=photoUpdated";
                } catch (Exception e) {
                    e.printStackTrace();
                    return "redirect:/ViewProfile.jsp?msg=photoError";
                }
            }
            return "redirect:/login.jsp";
        }

        return "redirect:/index.jsp";
    }

    /* ================= FORGOT PASSWORD HELPERS ================= */

    public UserModel getUserByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        return userRepository.findFirstByEmail(email.trim()).orElse(null);
    }

    public boolean updatePassword(String email, String newPassword) {
        if (email == null || newPassword == null) {
            return false;
        }

        Optional<UserModel> userOpt = userRepository.findFirstByEmail(email.trim());
        if (userOpt.isPresent()) {
            UserModel user = userOpt.get();
            user.setPassword(newPassword);
            userRepository.save(user);
            return true;
        }
        return false;
    }


}