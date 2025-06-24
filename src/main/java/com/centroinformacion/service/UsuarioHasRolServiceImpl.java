package com.centroinformacion.service;

import com.centroinformacion.entity.UsuarioHasRol;
import com.centroinformacion.repository.UsuarioHasRolRepository;
import com.centroinformacion.service.UsuarioHasRolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UsuarioHasRolServiceImpl implements UsuarioHasRolService {

    @Autowired
    private UsuarioHasRolRepository usuarioHasRolRepository;

    @Override
    public void insertaRol(UsuarioHasRol usuarioHasRol) {
        // Guardar la relación usuario-rol
        usuarioHasRolRepository.save(usuarioHasRol);
    }
}
