package com.centroinformacion.runner;

import com.centroinformacion.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class EncriptarContraseñasRunner implements CommandLineRunner {

    @Autowired
    private UsuarioService usuarioService;

    @Override
    public void run(String... args) throws Exception {
        usuarioService.encriptarContraseñas();
        System.out.println("Contraseñas encriptadas exitosamente.");
    }
}
