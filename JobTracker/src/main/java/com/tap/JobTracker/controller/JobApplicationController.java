package com.tap.JobTracker.controller;

import com.tap.JobTracker.model.JobApplication;
import com.tap.JobTracker.model.User;
import com.tap.JobTracker.service.JobApplicationService;
import com.tap.JobTracker.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
@RequestMapping("/jobs")
public class JobApplicationController {
    private final JobApplicationService jobService;
    private final UserService userService;

    public JobApplicationController(JobApplicationService jobService, UserService userService) {
        this.jobService = jobService;
        this.userService = userService;
    }

    @GetMapping
    public String getJobs(HttpSession session, Model model) {
        Optional<User> user = currentUser(session);
        if (user.isEmpty()) return "redirect:/auth/login";
        model.addAttribute("jobs", jobService.getAllJobs(user.get()));
        return "home";
    }

    @GetMapping("/add")
    public String showAddJobForm(HttpSession session, Model model) {
        if (currentUser(session).isEmpty()) return "redirect:/auth/login";
        model.addAttribute("job", new JobApplication());
        return "addJob";
    }

    @PostMapping("/add")
    public String addJob(@ModelAttribute JobApplication job, HttpSession session, Model model) {
        Optional<User> user = currentUser(session);
        if (user.isEmpty()) return "redirect:/auth/login";
        if (!validJob(job)) {
            model.addAttribute("error", "Company, position and status are required.");
            model.addAttribute("job", job);
            return "addJob";
        }
        job.setId(null);
        job.setCompany(job.getCompany().trim());
        job.setPosition(job.getPosition().trim());
        job.setStatus(job.getStatus().trim().toLowerCase(Locale.ROOT));
        job.setUser(user.get());
        jobService.addJob(job);
        return "redirect:/home";
    }

    @GetMapping("/edit/{id}")
    public String showEditJobForm(@PathVariable Long id, HttpSession session, Model model) {
        Optional<User> user = currentUser(session);
        if (user.isEmpty()) return "redirect:/auth/login";
        Optional<JobApplication> job = jobService.getJobById(id);
        if (job.isEmpty() || !ownsJob(job.get(), user.get())) return "redirect:/home";
        model.addAttribute("job", job.get());
        return "editJob";
    }

    @PostMapping("/update/{id}")
    public String updateJob(@PathVariable Long id, @ModelAttribute JobApplication submitted,
                            HttpSession session, Model model) {
        Optional<User> user = currentUser(session);
        if (user.isEmpty()) return "redirect:/auth/login";
        Optional<JobApplication> existing = jobService.getJobById(id);
        if (existing.isEmpty() || !ownsJob(existing.get(), user.get())) return "redirect:/home";
        if (!validJob(submitted)) {
            model.addAttribute("error", "Company, position and status are required.");
            model.addAttribute("job", existing.get());
            return "editJob";
        }
        JobApplication saved = existing.get();
        saved.setCompany(submitted.getCompany().trim());
        saved.setPosition(submitted.getPosition().trim());
        saved.setStatus(submitted.getStatus().trim().toLowerCase(Locale.ROOT));
        saved.setAppliedDate(submitted.getAppliedDate());
        jobService.addJob(saved);
        return "redirect:/home";
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<String> deleteJobApi(@PathVariable Long id, HttpSession session) {
        Optional<User> user = currentUser(session);
        if (user.isEmpty()) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Please log in.");
        Optional<JobApplication> job = jobService.getJobById(id);
        if (job.isEmpty()) return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Job not found.");
        if (!ownsJob(job.get(), user.get())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You cannot delete this job.");
        }
        jobService.deleteJob(id);
        return ResponseEntity.ok("Job deleted successfully.");
    }

    private Optional<User> currentUser(HttpSession session) {
        Object value = session.getAttribute("loggedInUserId");
        if (!(value instanceof Long userId)) return Optional.empty();
        return userService.findById(userId);
    }

    private boolean ownsJob(JobApplication job, User user) {
        return job.getUser() != null && job.getUser().getId() != null
                && job.getUser().getId().equals(user.getId());
    }

    private boolean validJob(JobApplication job) {
        return job.getCompany() != null && !job.getCompany().isBlank()
                && job.getPosition() != null && !job.getPosition().isBlank()
                && job.getStatus() != null
                && List.of("applied", "interviewing", "rejected", "offer")
                    .contains(job.getStatus().trim().toLowerCase(Locale.ROOT));
    }
}
