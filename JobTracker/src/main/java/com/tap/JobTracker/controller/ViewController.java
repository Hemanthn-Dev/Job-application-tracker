package com.tap.JobTracker.controller;

import com.tap.JobTracker.model.JobApplication;
import com.tap.JobTracker.model.User;
import com.tap.JobTracker.service.JobApplicationService;
import com.tap.JobTracker.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import java.util.Optional;

@Controller
public class ViewController {
    private final JobApplicationService jobApplicationService;
    private final UserService userService;

    public ViewController(JobApplicationService jobApplicationService, UserService userService) {
        this.jobApplicationService = jobApplicationService;
        this.userService = userService;
    }

    @GetMapping({"/", "/home"})
    public String showHomePage(Model model, HttpSession session) {
        Object idValue = session.getAttribute("loggedInUserId");
        if (idValue instanceof Long userId) {
            Optional<User> user = userService.findById(userId);
            if (user.isPresent()) {
                List<JobApplication> jobs = jobApplicationService.getAllJobs(user.get());
                model.addAttribute("jobs", jobs);
            }
        }
        return "home";
    }

    @GetMapping("/dashboard")
    public String showDashboardPage(HttpSession session) {
        return session.getAttribute("loggedInUserId") == null ? "redirect:/auth/login" : "main";
    }

    @GetMapping("/addJob")
    public String showAddJobPage() {
        return "redirect:/jobs/add";
    }

    @GetMapping("/error")
    public String showErrorPage() {
        return "error";
    }
}
