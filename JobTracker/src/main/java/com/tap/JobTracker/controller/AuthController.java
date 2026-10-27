package com.tap.JobTracker.controller;

import com.tap.JobTracker.model.User;
import com.tap.JobTracker.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password,
                        Model model, HttpServletRequest request) {
        Optional<User> foundUser = userService.findByEmail(email);
        if (foundUser.isPresent() && userService.passwordMatchesAndUpgradeLegacy(foundUser.get(), password)) {
            User user = foundUser.get();
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) oldSession.invalidate();
            HttpSession session = request.getSession(true);
            // Store only safe profile fields, never the password hash, in the session.
            session.setAttribute("loggedInUserId", user.getId());
            session.setAttribute("loggedInUserEmail", user.getEmail());
            session.setAttribute("loggedInUserName", user.getUserName());
            return "redirect:/home";
        }
        model.addAttribute("error", "Invalid email or password.");
        return "login";
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@RequestParam String userName, @RequestParam String email,
                               @RequestParam String password, Model model) {
        if (userName == null || userName.trim().isEmpty()) {
            model.addAttribute("error", "Full name is required.");
            return "register";
        }
        if (email == null || email.isBlank()) {
            model.addAttribute("error", "Email is required.");
            return "register";
        }
        if (password == null || password.length() < 8) {
            model.addAttribute("error", "Password must be at least 8 characters.");
            return "register";
        }
        User newUser = new User(null, userName.trim(), email.trim(), password);
        if (!userService.registerUser(newUser)) {
            model.addAttribute("error", "That email is already registered or invalid.");
            return "register";
        }
        return "redirect:/auth/login";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}
