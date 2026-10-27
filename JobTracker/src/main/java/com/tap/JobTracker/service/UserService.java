package com.tap.JobTracker.service;

import com.tap.JobTracker.model.User;
import com.tap.JobTracker.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Locale;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public boolean registerUser(User user) {
        String normalizedEmail = normalizeEmail(user.getEmail());
        if (normalizedEmail.isBlank() || userRepository.findByEmail(normalizedEmail).isPresent()) {
            return false;
        }
        user.setEmail(normalizedEmail);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);
        return true;
    }

    public Optional<User> findByEmail(String email) {
        if (email == null || email.isBlank()) return Optional.empty();
        return userRepository.findByEmail(normalizeEmail(email));
    }

    public Optional<User> findById(Long id) {
        return id == null ? Optional.empty() : userRepository.findById(id);
    }

    public void save(User user) {
        userRepository.save(user);
    }

    public boolean passwordMatchesAndUpgradeLegacy(User user, String rawPassword) {
        if (user == null || rawPassword == null || user.getPassword() == null) return false;
        String stored = user.getPassword();
        if (stored.startsWith("$2a$") || stored.startsWith("$2b$") || stored.startsWith("$2y$")) {
            return passwordEncoder.matches(rawPassword, stored);
        }
        // Upgrade legacy plain-text passwords on the first successful login.
        if (stored.equals(rawPassword)) {
            user.setPassword(passwordEncoder.encode(rawPassword));
            userRepository.save(user);
            return true;
        }
        return false;
    }

    private String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
    }
}
