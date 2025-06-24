package com.centroinformacion.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

public class Encoder {
    private static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

 // Método para encriptar contraseñas
    public static String encode(String password) {
        String encryptedPassword = passwordEncoder.encode(password);
        System.out.println("Texto plano: " + password);  // Imprime la contraseña en texto plano
        System.out.println("Contraseña encriptada: " + encryptedPassword);  // Imprime la contraseña encriptada
        return encryptedPassword;
    }
}
