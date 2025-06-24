package com.centroinformacion.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "usuario_has_incidencia")
public class UsuarioHasIncidencia {

    @EmbeddedId
    private UsuarioHasIncidenciaPK usuarioHasIncidenciaPk;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "idUsuario", nullable = false, insertable = false, updatable = false)
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "idIncidencia", nullable = false, insertable = false, updatable = false)
    private Incidencia incidencia;

}
