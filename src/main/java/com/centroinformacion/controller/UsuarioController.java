package com.centroinformacion.controller;

import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.entity.UsuarioHasRol;
import com.centroinformacion.entity.UsuarioHasRolPK;
import com.centroinformacion.service.UsuarioService;
import jakarta.servlet.http.HttpSession;

import com.centroinformacion.service.CorreoService;
import com.centroinformacion.service.UsuarioHasRolService;
import com.centroinformacion.repository.RolRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

@RestController
@RequestMapping("/usuario")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private RolRepository rolRepository;

    @Autowired
    private UsuarioHasRolService usuarioHasRolService;
    @Autowired
    private CorreoService correoService;
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    // Método para generar una contraseña aleatoria de 8 dígitos
    private String generarPasswordAleatoria() {
        Random random = new Random();
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            password.append(random.nextInt(10)); // Agregar dígitos aleatorios
        }
        return password.toString();
    }

    @PostMapping("/registrar")
    @ResponseBody
    public Map<String, Object> registrarUsuario(@ModelAttribute  Usuario usuario, RedirectAttributes flash, HttpSession session) {
        Map<String, Object> map = new HashMap<>();

        // Validación del campo 'apellidos'
        if (usuario.getApellidos() == null || usuario.getApellidos().trim().isEmpty()) {
            map.put("valid", "false");
            map.put("ERROR", "El campo 'apellidos' es obligatorio.");
            return map;
        }

        try {
            // Verificar si el login ya está registrado
            if (usuarioService.BuscarPorLogin(usuario.getLogin()).isPresent()) {
                map.put("ERROR", "El login ya está registrado.");
                map.put("valid", "false");
                return map;
            }

            // Verificar si el correo ya está registrado
            if (usuarioService.BuscarPorCorreo(usuario.getCorreo()).isPresent()) {
                map.put("ERROR", "El correo ya está registrado.");
                map.put("valid", "false");
                return map;
            }

            // Establecer "discapacitado" por defecto a 0
            usuario.setDiscapacitado(0);
usuario.setEstado(1);
            // Generar una contraseña aleatoria de 8 dígitos y encriptarla
            String passwordGenerado = generarPasswordAleatoria();
            System.out.println("Contraseña generada: " + passwordGenerado);  // Imprimir la contraseña en consola
            usuario.setPassword(passwordEncoder.encode(passwordGenerado));

            // Asignar la fecha de registro al usuario
            usuario.setFechaRegistro(new Date());
            usuario.setFotoPerfil("3b5da053-4add-4128-9223-24cb02ea9300_proveedor.png");

            // Registrar al usuario
            Usuario usuarioRegistrado = usuarioService.save(usuario);

            // Asignar el rol 4 al usuario recién registrado
            UsuarioHasRol usuarioHasRol = new UsuarioHasRol();
            UsuarioHasRolPK pk = new UsuarioHasRolPK();
            pk.setIdUsuario(usuarioRegistrado.getIdUsuario());
            pk.setIdRol(4); // Asigna el rol 4
            usuarioHasRol.setUsuarioHasRolPk(pk);

            Rol rol = rolRepository.findById(4).orElseThrow(() -> new RuntimeException("Rol no encontrado"));
            usuarioHasRol.setUsuario(usuarioRegistrado);
            usuarioHasRol.setRol(rol);

            usuarioHasRolService.insertaRol(usuarioHasRol);
            // Enviar correo de bienvenida con las credenciales
            String mensajeBienvenida = "¡Bienvenido " + usuario.getNombres() + " " + usuario.getApellidos() + "!\n\n" +
                "Tu usuario ha sido creado exitosamente.\n" +
                "Login: " + usuario.getLogin() + "\n" +
                "Contraseña: " + passwordGenerado + "\n\n" +
                "¡Disfruta de nuestros servicios!";
            correoService.enviarCorreo(usuario.getCorreo(), "Bienvenido a nuestra plataforma", mensajeBienvenida);

            map.put("MENSAJE", "Usuario registrado y rol asignado exitosamente.");
            map.put("valid", "true");

            // Aquí puedes enviar la contraseña generada en el cuerpo de la respuesta (solo para fines de prueba)
            // En producción nunca debes enviar la contraseña en texto plano
            map.put("passwordGenerado", passwordGenerado); // Para fines de prueba

        } catch (Exception e) {
            map.put("ERROR", "Error al registrar el usuario: " + e.getMessage());
            map.put("valid", "false");
        }
        return map;
    }

    // Endpoint para verificar si un usuario existe por login o correo
    @GetMapping("/verificar")
    @ResponseBody
    public Map<String, Object> verificarUsuario(@RequestParam("login") String login, @RequestParam("correo") String correo) {
        Map<String, Object> map = new HashMap<>();
        try {
            if (usuarioService.BuscarPorLogin(login).isPresent()) {
                map.put("ERROR", "El login ya está registrado.");
                map.put("valid", "false");
            } else if (usuarioService.BuscarPorCorreo(correo).isPresent()) {
                map.put("ERROR", "El correo ya está registrado.");
                map.put("valid", "false");
            } else {
                map.put("ERROR", "Usuario disponible.");
                map.put("valid", "true");
            }
        } catch (Exception e) {
            map.put("ERROR", "Error al verificar el usuario: " + e.getMessage());
            map.put("valid", "false");
        }
        return map;
    }
}
