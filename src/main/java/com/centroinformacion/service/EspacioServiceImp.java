package com.centroinformacion.service;

import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.centroinformacion.entity.Espacio;
import com.centroinformacion.repository.EspacioRepository;

@Service
public class EspacioServiceImp implements EspacioService {
    @Autowired
    private EspacioRepository repository;
  

    @Override
    public List<Espacio> listaTodos() {
        return repository.findByOrderByNumeroAscCustom();
    }

    @Override
    public Espacio insertaActualizaEspacio(Espacio obj) {
        return repository.save(obj);
    }

    @Override
    public List<Espacio> listaPorNumero(String numero) {
        return repository.findByNumero(numero);
    }

    @Override
    public Optional<Espacio> buscaEspacio(int idEspacio) {
        return repository.findById(idEspacio);
    }

    @Override
    public List<Espacio> listaPorNumeroIgualRegistra(String numero) {
        return repository.listaPorNumeroIgualRegistra(numero);
    }

    @Override
    public List<Espacio> listaPorNumeroIgualActualiza(String numero, int idEspacio) {
        return repository.listaPorNumeroIgualActualiza(numero, idEspacio);
    }

    @Override
    public List<Espacio> listaPorNumeros(String numero) {
        return repository.findByNumeroIgnoreCase(numero);
    }

    @Override
    public List<Espacio> listaPorNumeroLike(String filtro) {
        return repository.listaPorNumeroLike(filtro);
    }

    @Override
    public List<Espacio> listaConsultaEspacio(int estado_reserva, String numero, String piso, int acceso) {
        return repository.listaConsultaEspacio(estado_reserva, numero, piso, acceso);
    }

    @Override
    public List<Espacio> listaEspacioDisponibles() {
        return repository.listaEspacioDisponibles();
    }

    @Override
    public Espacio actualizarEspacio(Espacio espacio) {
        return repository.save(espacio);
    }

	@Override
	public List<Espacio> listaEspacioDisponibles(String filtro, Pageable pageable) {
		// TODO Auto-generated method stub
		return repository.findByFiltro(filtro, pageable);
	}

	@Override
	public Espacio obtenerEspacioPorId(Integer idEspacio) {
		// TODO Auto-generated method stub
		return repository.findById(idEspacio).orElse(null);
	}
}
