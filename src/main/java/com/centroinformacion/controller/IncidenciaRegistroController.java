package com.centroinformacion.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Autowired;

import com.centroinformacion.entity.Incidencia;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.service.IncidenciaService;
import com.centroinformacion.util.AppSettings;

import jakarta.servlet.http.HttpSession;

@Controller
public class IncidenciaRegistroController {
	 @Autowired
	    private IncidenciaService incidenciaService;
	@PostMapping("/registrarIncidencia")
    @ResponseBody
    public Map<String, Object> registrarIncidencia(Incidencia obj, HttpSession session) {
        Map<String, Object> map = new HashMap<>();

        // Obtener el usuario de la sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            map.put("MENSAJE", "Usuario no autenticado");
            return map;
        }

        // Configurar campos necesarios de la incidencia
        obj.setUsuarioRegistro(usuario); // Usuario de la sesión
        obj.setEstado(AppSettings.ACTIVO);
        obj.setUsuarioActualiza(usuario); // Usuario de la sesión
        obj.setFechaRegistro(new Date());
        obj.setFechaActualizacion(new Date());

        // Guardar la incidencia
        Incidencia objSalida = incidenciaService.insertaActualizaIncidencia(obj);
        if (objSalida == null) {
            map.put("MENSAJE", "Error en el registro de la incidencia");
            return map;
        }

        map.put("MENSAJE", "Registro de incidencia exitoso");
        return map;
    }
}
