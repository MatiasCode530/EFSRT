package com.centroinformacion.service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Pageable;

import com.centroinformacion.entity.Vehiculo;

public interface VehiculoService {

    // Lista todos los veh&iacuteculos
    public abstract List<Vehiculo> listaTodos();

    // Inserta o actualiza un veh&iacuteculo
    public abstract Vehiculo insertaActualizaVehiculo(Vehiculo obj);

    // Lista veh&iacuteculos por placa exacta
    public abstract List<Vehiculo> listaPorPlacaExacta(String placa);

    // Busca un veh&iacuteculo por su ID
    public abstract Optional<Vehiculo> buscaVehiculo(int idVehiculo);

    // Lista veh&iacuteculos por modelo o marca
    public abstract List<Vehiculo> listaPorModeloOMarca(String modelo, String marca);

    // Lista veh&iacuteculos por modelo o marca utilizando un filtro (like)
    public abstract List<Vehiculo> listaPorModeloMarcaLike(String filtro);

    // Validaciones
 
    // Lista veh&iacuteculos por placa exacta excluyendo un ID espec&iacutefico
    public abstract List<Vehiculo> listaPorPlacaExactaActualiza(String placa, int idVehiculo);

    // Consultas avanzadas
    // Lista veh&iacuteculos con m&uacute;ltiples filtros: estado, usuario, modelo, marca, fechas, color y placa
    public abstract List<Vehiculo> listaConsultaVehiculo(int estado, int idUsuarioRegistro, String filtroModeloMarca, Date fechaDesde, Date fechaHasta, String placa);

    // Consulta paginada por modelo, marca o concatenaci&oacute;n de ambos
    public abstract List<Vehiculo> listaVehiculo(String filtro, Pageable pageable);
    public abstract     List<Vehiculo> findByUsuarioRegistroId(int idUsuarioRegistro);


}

