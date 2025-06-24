package com.centroinformacion.controller;

import java.time.LocalTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.centroinformacion.entity.Incidencia;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.entity.UsuarioHasIncidencia;
import com.centroinformacion.entity.UsuarioHasIncidenciaPK;
import com.centroinformacion.service.IncidenciaService;
import com.centroinformacion.service.UsuarioService;

import jakarta.servlet.http.HttpSession;

@Controller
public class IncidenciaTransaccionController {

    @Autowired 
    private UsuarioService usuarioService;

    @Autowired 
    private IncidenciaService incidenciaService;

    @ResponseBody
    @GetMapping("/listaIncidencias")
    public List<Incidencia> listaIncidencias() {
        return incidenciaService.listaIncidencias(); 
    }

    @ResponseBody
    @GetMapping("/listaIncidenciasDeUsuario")
    public List<UsuarioHasIncidencia> listaIncidenciasDeUsuario(int idUsuario) {
        return usuarioService.traerIncidenciasDeUsuario(idUsuario);
    }

    @PostMapping("/crearIncidenciaYAsignarUsuarios")
    @ResponseBody
    public HashMap<String, Object> crearIncidenciaYAsignarUsuarios(
            @RequestParam String descripcion,
            @RequestParam List<Integer> idUsuarios,
            HttpSession session) {  // Usamos la sesión para obtener al usuario registrado

        HashMap<String, Object> maps = new HashMap<>();

        // Obtener el usuario de la sesión
        Usuario usuarioRegistro = (Usuario) session.getAttribute("objUsuario");
        if (usuarioRegistro == null) {
            maps.put("ERROR", "Usuario no encontrado en la sesión");
            return maps;
        }

        // Crear la incidencia
        Incidencia nuevaIncidencia = new Incidencia();
        nuevaIncidencia.setDescripcion(descripcion);
        nuevaIncidencia.setFechaRegistro(new Date());  // Asignar la fecha de registro actual
        nuevaIncidencia.setFechaIncidencia(new Date()); 
        nuevaIncidencia.setHora(LocalTime.now());  // Establecer la hora actual
        nuevaIncidencia.setFechaActualizacion(new Date());  // Asignar la fecha de actualización actual
        nuevaIncidencia.setEstado(1);  // Asignar un estado (por ejemplo, 1=Abierta)

        // Establecer el usuario que está registrando la incidencia
        nuevaIncidencia.setUsuarioRegistro(usuarioRegistro);
        nuevaIncidencia.setUsuarioActualiza(usuarioRegistro);  // Asignar el mismo usuario para la actualización

        // Guardar la nueva incidencia
        nuevaIncidencia = incidenciaService.guardarIncidencia(nuevaIncidencia);

        // Verificar si la incidencia se guardó correctamente
        if (nuevaIncidencia != null) {
            // Asignar usuarios a la nueva incidencia
            for (Integer idUsuario : idUsuarios) {
                Usuario usuario = usuarioService.buscarUsuarioPorId(idUsuario);
                if (usuario != null) {
                    // Crear el objeto UsuarioHasIncidenciaPK con los IDs
                    UsuarioHasIncidenciaPK usuarioHasIncidenciaPK = new UsuarioHasIncidenciaPK();
                    usuarioHasIncidenciaPK.setIdUsuario(idUsuario);
                    usuarioHasIncidenciaPK.setIdIncidencia(nuevaIncidencia.getIdIncidencia());

                    // Crear el objeto UsuarioHasIncidencia con la clave compuesta
                    UsuarioHasIncidencia usuarioHasIncidencia = new UsuarioHasIncidencia();
                    usuarioHasIncidencia.setUsuarioHasIncidenciaPk(usuarioHasIncidenciaPK);
                    usuarioHasIncidencia.setUsuario(usuario);
                    usuarioHasIncidencia.setIncidencia(nuevaIncidencia);

                    // Asignar la incidencia al usuario (guardando en la base de datos)
                    usuarioService.asignarIncidencia(usuarioHasIncidencia);
                }
            }
            maps.put("MENSAJE", "Incidencia creada y usuarios asignados con éxito");
        } else {
            maps.put("ERROR", "Error al crear la incidencia");
        }

        return maps;
    }



}
