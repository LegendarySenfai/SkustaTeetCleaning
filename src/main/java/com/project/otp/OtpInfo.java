package com.project.otp;

import java.io.Serializable;
import java.time.LocalDateTime;

public class OtpInfo implements Serializable {
    private String code;
    private Long userId;
    private Long appointmentId;
    private LocalDateTime expiresAt;
    private String purpose;

    public OtpInfo() {}

    public OtpInfo(String code, Long userId, Long appointmentId, LocalDateTime expiresAt, String purpose) {
        this.code = code;
        this.userId = userId;
        this.appointmentId = appointmentId;
        this.expiresAt = expiresAt;
        this.purpose = purpose;
    }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getAppointmentId() { return appointmentId; }
    public void setAppointmentId(Long appointmentId) { this.appointmentId = appointmentId; }
    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime expiresAt) { this.expiresAt = expiresAt; }
    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }
}
