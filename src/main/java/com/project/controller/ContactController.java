package com.project.controller;

import com.project.otp.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/contact")
public class ContactController {

    private static final String SYSTEM_EMAIL = "skustateethclinic@gmail.com";

    @Autowired
    private EmailService emailService;

    // Simple DTO for request body
    public static class ContactRequest {
        public String name;
        public String email;
        public String message;

        // empty ctor + getters/setters not strictly required for Jackson if fields are public
    }

    private static final Pattern SIMPLE_EMAIL_RE = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

    @PostMapping(value = "/send",
                 consumes = MediaType.APPLICATION_JSON_VALUE,
                 produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String,Object>> sendContact(@RequestBody ContactRequest req) {
        Map<String,Object> resp = new HashMap<>();

        if (req == null) {
            resp.put("success", false);
            resp.put("message", "Invalid request.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resp);
        }

        String name = (req.name == null) ? "" : req.name.trim();
        String email = (req.email == null) ? "" : req.email.trim();
        String message = (req.message == null) ? "" : req.message.trim();

        if (name.length() < 8) {
            resp.put("success", false);
            resp.put("message", "Name must be at least 8 characters long.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resp);
        }
        if (!SIMPLE_EMAIL_RE.matcher(email).matches()) {
            resp.put("success", false);
            resp.put("message", "Please provide a valid email address.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resp);
        }
        if (message.length() < 8) {
            resp.put("success", false);
            resp.put("message", "Message must be at least 8 characters long.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resp);
        }

        // prepare email content for system admin
        String subject = "Website Contact from " + name;
        StringBuilder body = new StringBuilder();
        body.append("You have received a new message via the website contact form Mr.Skusta.\n\n");
        body.append("Sender name: ").append(name).append("\n");
        body.append("Sender email: ").append(email).append("\n\n");
        body.append("Message:\n").append(message).append("\n");

        try {
            // uses your existing EmailService method signature used elsewhere in code
            emailService.sendOtpEmail(SYSTEM_EMAIL, subject, body.toString());

            resp.put("success", true);
            resp.put("message", "Your message has been sent. Thank you!");
            return ResponseEntity.ok(resp);
        } catch (Exception ex) {
            // log the exception if you have a logger (not included here to keep code minimal)
            resp.put("success", false);
            resp.put("message", "Failed to send message. Please try again later.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
        }
    }
}
