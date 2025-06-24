package com.centroinformacion.entity;

import java.time.LocalTime;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "incidencia")
public class Incidencia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idIncidencia;

    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUsuarioRegistro")
    private Usuario usuarioRegistro;

    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUsuarioActualiza")
    private Usuario usuarioActualiza;
    
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd hh:mm:ss")
    private Date fechaRegistro;

    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd hh:mm:ss")
    private Date fechaActualizacion;

    @Temporal(TemporalType.DATE)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private Date fechaIncidencia;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm") // Formato de hora
    @Temporal(TemporalType.TIME)
    @DateTimeFormat(pattern = "HH:mm") // Formato de hora para binding
    private LocalTime hora; // Hora de la solicitud
    private String descripcion;
    private int estado;  // Estado de la incidencia (por ejemplo, 1=Abierta, 2=Cerrada)

    @JsonIgnore
    @OneToMany(mappedBy = "incidencia")
    private List<UsuarioHasIncidencia> usuariosHasIncidencia;  // Relación con la tabla intermedia

    // Métodos adicionales si son necesarios, por ejemplo, para obtener el nombre del usuario que registró o actualizó
    public String getUsuarioRegistroNombre() {
        return usuarioRegistro != null ? usuarioRegistro.getNombreCompleto() : "";
    }

    public String getUsuarioActualizaNombre() {
        return usuarioActualiza != null ? usuarioActualiza.getNombreCompleto() : "";
    }
}

