package com.centroinformacion.entity;

import java.util.Date;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "espacio") // Cambiar el nombre de la tabla a "espacio"
public class Espacio {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idEspacio; // ID del espacio
    private String numero; // N&uacute;mero del espacio
    private String pabellon; // Pabell&oacute;n del espacio
    private String piso; // Piso del espacio
    private int acceso; // 0 para libre, 1 para restringido
    private int estado_reserva; // 0 para no reservado, 1 para reservado

    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date fechaRegistro; // Fecha de registro

    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date fechaActualizacion; // Fecha de actualizaci&oacute;n

    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUsuarioRegistro") // Relaci&oacute;n con el usuario que registr&oacute;
    private Usuario usuarioRegistro;

    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUsuarioActualiza") // Relaci&oacute;n con el usuario que actualiz&oacute;
    private Usuario usuarioActualiza;

    public String getReporteEstado() {
        return estado_reserva == 1 ? "reservado" : "disponible"; // M&eacute;todo para obtener el estado de reserva
    }
}
