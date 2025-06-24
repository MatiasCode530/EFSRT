package com.centroinformacion.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.centroinformacion.entity.Opcion;
import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.service.UsuarioService;
import com.centroinformacion.util.PasswordUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private UsuarioService servicio;

    @PostMapping("/login")
    public String login(Usuario user, HttpSession session, HttpServletRequest request) {
        // Buscar usuario en la base de datos
        Usuario usuario = servicio.login(user);

        // Validar si no existe
        if (usuario == null) {
            request.setAttribute("mensaje", "Usuario o contraseña incorrectos");
            return "intranetLogin";
        }

        // Validar contraseña
        if (!PasswordUtil.matches(user.getPassword(), usuario.getPassword())) {
            request.setAttribute("mensaje", "Usuario o contraseña incorrectos");
            return "intranetLogin";
        }

        // Validar estado del usuario
        if (usuario.getEstado() == 0) {
            request.setAttribute("mensaje", "El usuario no está activo en este ciclo. No puede iniciar sesión.");
            return "intranetLogin";
        }

        // Obtener roles y menús
        List<Rol> roles = servicio.traerRolesDeUsuario(usuario.getIdUsuario());
        List<Opcion> menus = servicio.traerEnlacesDeUsuario(usuario.getIdUsuario());

        // Filtrar menús por tipo
        List<Opcion> menusTipo1 = menus.stream().filter(p -> p.getTipo() == 1).toList(); // Profesor
        List<Opcion> menusTipo2 = menus.stream().filter(p -> p.getTipo() == 2).toList(); // Alumno
        List<Opcion> menusTipo3 = menus.stream().filter(p -> p.getTipo() == 3).toList(); // Seguridad
        List<Opcion> menusTipo4 = menus.stream().filter(p -> p.getTipo() == 4).toList(); // Proveedores
        List<Opcion> menusTipo5 = menus.stream().filter(p -> p.getTipo() == 5).toList(); // Supervisores

        // Guardar atributos en sesión
        session.setAttribute("idUsuario", usuario.getIdUsuario());
        session.setAttribute("objUsuario", usuario);
        session.setAttribute("objMenusTipo1", menusTipo1);
        session.setAttribute("objMenusTipo2", menusTipo2);
        session.setAttribute("objMenusTipo3", menusTipo3);
        session.setAttribute("objMenusTipo4", menusTipo4);
        session.setAttribute("objMenusTipo5", menusTipo5);
        session.setAttribute("objRoles", roles);

        return "intranetHome"; // Redirige al home
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        // Cerrar sesión
        session.invalidate();
        response.setHeader("Cache-control", "no-cache");
        response.setHeader("Expires", "0");
        response.setHeader("Pragma", "no-cache");
        request.setAttribute("mensaje", "El usuario salió de sesión");
        return "intranetLogin";
    }
}
