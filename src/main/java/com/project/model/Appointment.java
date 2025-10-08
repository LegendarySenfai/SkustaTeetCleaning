package com.project.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "appointments",
    uniqueConstraints = {@UniqueConstraint(columnNames = {"dentist_id","appointment_date","appointment_start"})})
public class Appointment implements Serializable {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "patient_id")
    private User patient;

    @ManyToOne
    @JoinColumn(name = "dentist_id")
    private Dentist dentist;

    @ManyToMany
    @JoinTable(name = "appointment_services",
            joinColumns = @JoinColumn(name = "appointment_id"),
            inverseJoinColumns = @JoinColumn(name = "service_id"))
    private Set<ServiceEntity> services = new HashSet<>();

    private LocalDate appointmentDate;
    private LocalTime appointmentStart;
    private LocalTime appointmentEnd;
    private String status;
    private LocalDateTime createdAt = LocalDateTime.now();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getPatient() { return patient; }
    public void setPatient(User patient) { this.patient = patient; }
    public Dentist getDentist() { return dentist; }
    public void setDentist(Dentist dentist) { this.dentist = dentist; }
    public Set<ServiceEntity> getServices() { return services; }
    public void setServices(Set<ServiceEntity> services) { this.services = services; }
    public LocalDate getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(LocalDate appointmentDate) { this.appointmentDate = appointmentDate; }
    public LocalTime getAppointmentStart() { return appointmentStart; }
    public void setAppointmentStart(LocalTime appointmentStart) { this.appointmentStart = appointmentStart; }
    public LocalTime getAppointmentEnd() { return appointmentEnd; }
    public void setAppointmentEnd(LocalTime appointmentEnd) { this.appointmentEnd = appointmentEnd; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
