package com.centroinformacion.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.centroinformacion.entity.Opcion;
import com.centroinformacion.repository.OpcionRepository;

@Service
public class OpcionServiceImp implements OpcionService{
	@Autowired
	private OpcionRepository repository;

	@Override
	public List<Opcion> listaOpcion() {
		return repository.findAll();
	}

}
