package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.model.review;

@WebServlet("/reviewController")
public class reviewController extends HttpServlet {
    private static final long serialVersionUID = 1L;
     
    public reviewController() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     
        response.sendRedirect("review.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("Action Received: " + action);
      
        if ("review".equalsIgnoreCase(action)) {
            try {
                review rmodel = new review();
                rmodel.setName(request.getParameter("name"));
                rmodel.setText(request.getParameter("text"));
                
           
                String rawRating = request.getParameter("rating");
                if (rawRating != null && !rawRating.trim().isEmpty()) {
                    rmodel.setRating(Integer.parseInt(rawRating.trim()));
                } else {
                    response.sendRedirect("review.jsp?msg=invalidrating");
                    return;
                }

                if (rmodel.getRating() < 1 || rmodel.getRating() > 5) {
                    response.sendRedirect("review.jsp?msg=invalidrating");
                    return; 
                } else {
                  
                    System.out.println("Review Processed: " + rmodel.getName() + " | Rating: " + rmodel.getRating());
                   
                    
                    response.sendRedirect("review.jsp?msg=success");
                    return;
                }
                
            } catch (NumberFormatException nfe) {
                System.err.println("Data Parsing Error: Rating parameter was non-numeric.");
                response.sendRedirect("review.jsp?msg=invalidrating");
                return;
            } catch (Exception e) {
                System.err.println("System Processing Failure: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("review.jsp?msg=error");
                return;
            }
        }
        
        System.out.println("Bypassed review condition block. Unknown Action: " + action);
        response.sendRedirect("review.jsp?msg=error");
    }
}