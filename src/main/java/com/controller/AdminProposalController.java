package com.controller;

import com.Repository.ProposalRepository;
import com.model.Proposal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminProposalController {

    @Autowired
    private ProposalRepository proposalRepository;


    // =====================================================
    // SHOW ALL PROPOSALS
    // URL: /admin/admin-praposal
    // =====================================================

    @GetMapping("/admin-praposal")
    public String showProposals(
            @RequestParam(value = "msg", required = false) String msg,
            Model model) {

        List<Proposal> proposals = proposalRepository.findAll();

        model.addAttribute("proposals", proposals);

        if (msg != null) {
            model.addAttribute("msg", msg);
        }

        return "admin-praposal";
    }

    // =====================================================
    // CREATE PROPOSAL
    // URL: /admin/admin-praposal
    // METHOD: POST
    // =====================================================

    @PostMapping("/admin-praposal")
    public String createProposal(

            @RequestParam("action") String action,

            @RequestParam("company_name") String companyName,

            @RequestParam("company_email") String companyEmail,

            @RequestParam("proposal_title") String proposalTitle,

            @RequestParam(value = "proposal_desc", required = false)
            String proposalDesc,

            @RequestParam(value = "terms", required = false)
            String terms,

            @RequestParam(value = "deal_amount", required = false)
            String dealAmount,

            RedirectAttributes redirectAttributes) {

        if ("create".equals(action)) {

            Proposal proposal = new Proposal();

            proposal.setCompanyName(companyName);
            proposal.setCompanyEmail(companyEmail);
            proposal.setProposalTitle(proposalTitle);
            proposal.setProposalDesc(proposalDesc);
            proposal.setTerms(terms);
            proposal.setDealAmount(dealAmount);

            // Default status
            proposal.setStatus("Pending");

            // Current date
            proposal.setCreatedDate(
                    LocalDate.now().toString()
            );

            // Save using Spring Data JPA Repository
            proposalRepository.save(proposal);

            redirectAttributes.addAttribute(
                    "msg",
                    "success"
            );
        }

        return "redirect:/admin/admin-praposal";
    }


    // =====================================================
    // UPDATE PROPOSAL STATUS
    // URL:
    // /admin/admin-praposal/status?id=1&status=accepted
    // =====================================================

    @GetMapping("/admin-praposal/status")
    public String updateStatus(

            @RequestParam("id") int id,

            @RequestParam("status") String status,

            RedirectAttributes redirectAttributes) {

        Proposal proposal =
                proposalRepository.findById(id).orElse(null);

        if (proposal != null) {

            proposal.setStatus(status);

            proposalRepository.save(proposal);

            redirectAttributes.addAttribute(
                    "msg",
                    "updated"
            );
        }

        return "redirect:/admin/admin-praposal";
    }


    // =====================================================
    // DELETE PROPOSAL
    // URL:
    // /admin/admin-praposal/delete?id=1
    // =====================================================

    @GetMapping("/admin-praposal/delete")
    public String deleteProposal(

            @RequestParam("id") int id,

            RedirectAttributes redirectAttributes) {

        if (proposalRepository.existsById(id)) {

            proposalRepository.deleteById(id);

            redirectAttributes.addAttribute(
                    "msg",
                    "deleted"
            );
        }

        return "redirect:/admin/admin-praposal";
    }
}