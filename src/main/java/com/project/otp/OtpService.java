package com.project.otp;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;

@Service
public class OtpService {

    @Value("${app.otp.expiry-minutes:10}")
    private int expiryMinutes;

    private final Random rand = new Random();

    private String generateCode() {
        int code = 100000 + rand.nextInt(900000);
        return String.valueOf(code);
    }

    public OtpInfo createAndStoreOtp(HttpSession session, Long userId, Long appointmentId, String purpose) {
        String code = generateCode();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(expiryMinutes);
        OtpInfo info = new OtpInfo(code, userId, appointmentId, expiresAt, purpose);
        String key = sessionKey(purpose, appointmentId, userId);
        session.setAttribute(key, info);
        return info;
    }

    public OtpInfo getOtpFromSession(HttpSession session, Long appointmentId, Long userId, String purpose) {
        String key = sessionKey(purpose, appointmentId, userId);
        Object o = session.getAttribute(key);
        if (o instanceof OtpInfo) return (OtpInfo) o;
        return null;
    }

    public void removeOtpFromSession(HttpSession session, Long appointmentId, Long userId, String purpose) {
        session.removeAttribute(sessionKey(purpose, appointmentId, userId));
    }

    private String sessionKey(String purpose, Long appointmentId, Long userId) {
        String idPart = (appointmentId != null) ? "A" + appointmentId : "U" + (userId != null ? userId : "0");
        return "OTP_" + purpose + "_" + idPart;
    }

    public boolean isExpired(OtpInfo info) {
        return info == null || info.getExpiresAt() == null || info.getExpiresAt().isBefore(LocalDateTime.now());
    }
}
