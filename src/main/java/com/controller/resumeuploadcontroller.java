package com.controller;

import java.io.File;
import java.util.UUID;

import com.model.resumemodel;
import com.Repository.ResumeRepository;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.stereotype.Controller;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class resumeuploadcontroller {

    @Autowired
    private ResumeRepository resumeRepository; // DAO ki jagah direct repository inject ki

    @GetMapping("/UploadServlet")
    public String doGet() {
        return "redirect:/index.jsp";
    }

    @PostMapping("/UploadServlet")
    public String doPost(@RequestParam("resume") MultipartFile resumeFile, HttpServletRequest request) {

        String uploadPath = request.getServletContext().getRealPath("")
                + File.separator + "uploads";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            String fileName = resumeFile.getOriginalFilename();

            if (fileName != null && !fileName.isEmpty()) {

                String uniqueName = UUID.randomUUID().toString() + "_" + fileName;

                File destFile = new File(uploadPath + File.separator + uniqueName);
                resumeFile.transferTo(destFile);

                // Model data set kiya
                resumemodel rm = new resumemodel();
                rm.setFilename(fileName);
                rm.setFilepath(uniqueName);

                resumeRepository.save(rm);

                return "redirect:/index.jsp?msg=upload_success";
            } else {
                return "redirect:/index.jsp?msg=no_file";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/index.jsp?msg=error";
        }
    }
}