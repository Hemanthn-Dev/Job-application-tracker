package com.tap.JobTracker.service;

import com.tap.JobTracker.model.User;
import com.tap.JobTracker.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserServiceTest {
    private UserRepository userRepository;
    private PasswordEncoder passwordEncoder;
    private UserService userService;

    @BeforeEach
    void setUp() {
        userRepository = mock(UserRepository.class);
        passwordEncoder = new BCryptPasswordEncoder();
        userService = new UserService(userRepository, passwordEncoder);
    }

    @Test
    void registrationNormalizesEmailAndStoresHashedPassword() {
        when(userRepository.findByEmail("hemanth@example.com")).thenReturn(Optional.empty());
        User user = new User(null, "Hemanth", " Hemanth@Example.com ", "safe-password");

        assertTrue(userService.registerUser(user));

        verify(userRepository).save(user);
        assertEquals("hemanth@example.com", user.getEmail());
        assertNotEquals("safe-password", user.getPassword());
        assertTrue(passwordEncoder.matches("safe-password", user.getPassword()));
    }

    @Test
    void duplicateEmailIsRejected() {
        when(userRepository.findByEmail("hemanth@example.com"))
                .thenReturn(Optional.of(new User(1L, "Existing", "hemanth@example.com", "hash")));

        assertFalse(userService.registerUser(
                new User(null, "Hemanth", "hemanth@example.com", "safe-password")));
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void successfulLegacyPasswordLoginUpgradesPasswordHash() {
        User legacyUser = new User(1L, "Hemanth", "hemanth@example.com", "old-plain-password");

        assertTrue(userService.passwordMatchesAndUpgradeLegacy(legacyUser, "old-plain-password"));

        assertNotEquals("old-plain-password", legacyUser.getPassword());
        assertTrue(passwordEncoder.matches("old-plain-password", legacyUser.getPassword()));
        verify(userRepository).save(legacyUser);
    }

    @Test
    void incorrectPasswordIsRejected() {
        User user = new User(1L, "Hemanth", "hemanth@example.com",
                passwordEncoder.encode("correct-password"));

        assertFalse(userService.passwordMatchesAndUpgradeLegacy(user, "wrong-password"));
        verify(userRepository, never()).save(any(User.class));
    }
}
