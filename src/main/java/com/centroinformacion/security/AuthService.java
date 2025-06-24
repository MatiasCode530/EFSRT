package com.centroinformacion.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.centroinformacion.entity.Usuario;
import com.centroinformacion.repository.UsuarioRepository;

@Service
public class AuthService {

    @Autowired
    private UsuarioRepository usuarioRepository; // Repositorio de usuarios

    @Autowired
    private Decoder decoder; // Para validar las contraseñas

    // Método para validar el inicio de sesión
    public boolean validarLogin(String login, String password) {
        // 1. Recuperar el usuario de la base de datos
        Usuario usuario = usuarioRepository.findByLogin(login);
        
        if (usuario != null) {
            // 2. Comparar la contraseña ingresada con la almacenada
            return decoder.matches(password, usuario.getPassword());
        }
        return false; // Usuario no encontrado
    }
}