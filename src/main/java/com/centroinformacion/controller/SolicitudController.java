package com.centroinformacion.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.centroinformacion.entity.Solicitud;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.repository.SolicitudIngresoRepository;
@RestController
@RequestMapping("/api")
public class SolicitudController {
	
	  @Autowired
	    private SolicitudIngresoRepository solicitudIngresoRepository;

		@GetMapping("/solicitudes/porRol/{idRol}")
		public List<Solicitud> getSolicitudesPorRol(@PathVariable int idRol) {
		    return solicitudIngresoRepository.findSolicitudesPorRol(idRol);
		}
		 
		@GetMapping("/solicitudes/activas")
		public List<Map<String, Object>> getSolicitudesActivas() {
		    List<Solicitud> solicitudes = solicitudIngresoRepository.findSolicitudesActivas();
		    List<Map<String, Object>> usuarios = new ArrayList<>();

		    for (Solicitud solicitud : solicitudes) {
		        Map<String, Object> usuarioData = new HashMap<>();
		        if (solicitud.getUsuarioRegistro() != null) {
		            usuarioData.put("idUsuario", solicitud.getUsuarioRegistro().getIdUsuario());
		            usuarioData.put("nombres", solicitud.getUsuarioRegistro().getNombres());
		            usuarioData.put("apellidos", solicitud.getUsuarioRegistro().getApellidos());
		            usuarioData.put("correo", solicitud.getUsuarioRegistro().getCorreo());
		            usuarioData.put("nombreCompleto", solicitud.getUsuarioRegistro().getNombres() + " " + solicitud.getUsuarioRegistro().getApellidos());
		        }
		        usuarios.add(usuarioData);
		    }

		    return usuarios;
		}




}