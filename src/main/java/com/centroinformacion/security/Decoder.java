package com.centroinformacion.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
@Component
public class Decoder {
	private static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Método para validar contraseñas
    public static boolean matches(String rawPassword, String encryptedPassword) {
        boolean isMatch = passwordEncoder.matches(rawPassword, encryptedPassword);
        System.out.println("Contraseña en texto plano: " + rawPassword);  // Imprime la contraseña en texto plano
        System.out.println("Contraseña encriptada almacenada: " + encryptedPassword);  // Imprime la contraseña encriptada en la BD
        System.out.println("¿Coinciden?: " + isMatch);  // Imprime si las contraseñas coinciden
        return isMatch;
    }
}
