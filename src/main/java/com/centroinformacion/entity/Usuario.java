package com.centroinformacion.entity;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "usuario")
public class Usuario {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int idUsuario;
	private String nombres;
	private String apellidos;
	private String dni;
	private String login;
	private String password;
	private String correo;
	private String fotoPerfil;
	private String direccion;
    private int estado; // Estado de la solicitud

    private int discapacitado; // Estado de la incidencia
    private String codigoVerificacion;

	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd hh:mm:ss")
	private Date fechaRegistro;
	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private Date expiracionCodigo;


	
	@Temporal(TemporalType.DATE)
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd" , timezone = "America/Lima")
	private Date fechaNacimiento;
	
	public String getNombreCompleto() {
		return nombres.concat(" ").concat(apellidos);
	}
	@JsonManagedReference
	@OneToMany(mappedBy = "usuario")
	private List<UsuarioHasRol> usuarioHasRol;
	
	@JsonIgnore
	@OneToMany(mappedBy = "usuario")
	private List<UsuarioHasIncidencia> usuarioHasIncidencia; // Relación con incidencia
}
