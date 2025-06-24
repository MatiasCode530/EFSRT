<jsp:include page="intranetValida.jsp" />
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Expires" content="-1" />
    <meta http-equiv="Cache-Control" content="private" />
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />

    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="js/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/bootstrapValidator.js"></script>
    <script type="text/javascript" src="js/global.js"></script>
    <!-- Incluir jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-validator/0.5.3/js/bootstrapValidator.min.js"></script>

    <!-- Incluir SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.6.0/dist/sweetalert2.all.min.js"></script>

    <link rel="stylesheet" href="css/bootstrap.css" />
    <link rel="stylesheet" href="css/dataTables.bootstrap.min.css" />
    <link rel="stylesheet" href="css/bootstrapValidator.css" />

    <title>Registro Veh&iacute;culo</title>

    <style>
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        h4 {
            text-align: center;
            margin-bottom: 20px;
        }

        body {
            padding-top: 90px;
        }

        .navbar-fixed-top {
            height: 100px;
        }
    </style>
</head>

<body>
    <jsp:include page="intranetCabecera.jsp" />

    <div class="container">
        <div class="form-container">
            <h4>Registro de Veh&iacute;culo</h4>
            <form id="id_form" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label class="control-label" for="id_tipoVehiculo">Tipo</label>
                    <select class="form-control" id="id_tipoVehiculo" name="tipoVehiculo" required>
                        <option value="">Seleccione un tipo</option>
                        <!-- Las opciones se llenar&aacute;n aqu&iacute; mediante AJAX -->
                    </select>
                </div>

                <div class="form-group">
                    <label for="id_marca">Marca:</label>
                    <select id="id_marca" class="form-control" required name="marca">
                        <option value="">Seleccione una marca</option>
                        <!-- Las marcas se llenar&aacute;n aqu&iacute; mediante AJAX -->
                    </select>
                </div>

                <div class="form-group">
                    <label for="id_modelo">Modelo:</label>
                    <select id="id_modelo" class="form-control" required name="modelo">
                        <option value="">Seleccione un modelo</option>
                        <!-- Los modelos se llenar&aacute;n aqu&iacute; seg&uacute;n la marca seleccionada -->
                    </select>
                </div>

                <div class="form-group">
                    <label class="control-label" for="id_placa">Placa</label>
                    <input class="form-control" type="text" id="id_placa" name="placa" placeholder="Ingrese la placa"
                        maxlength="7">
                </div>

                <div class="form-group">
                    <label for="id_tipo">Tipo de Veh&iacute;culo:</label>
                    <input type="text" id="id_tipo" class="form-control" readonly name="tipo">
                </div>

                <div class="form-group">
                    <label class="control-label" for="id_imagen">Imagen del Veh&iacute;culo</label>
                    <input class="form-control-file" type="file" id="id_imagen" name="file" accept="image/*" required>
                </div>

                <div class="form-group text-center">
                    <button id="id_registrar" type="button" class="btn btn-primary">Registrar</button>
                </div>
            </form>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            // Cargar tipos de vehículo al iniciar
            cargarTiposVehiculo();
    
            function cargarTiposVehiculo() {
                $.ajax({
                    type: "GET",
                    url: "http://localhost:8070/api/vehiculos",
                    success: function (data) {
                        var tiposVehiculo = new Set();
                        $.each(data, function (index, vehiculo) {
                            tiposVehiculo.add(vehiculo.transporte);  // Ahora se usa 'transporte' en lugar de 'tipo'
                        });
    
                        var $tipoVehiculoSelect = $("#id_tipoVehiculo");
                        $tipoVehiculoSelect.empty();
                        $tipoVehiculoSelect.append("<option value=''>Seleccione un tipo</option>");
    
                        tiposVehiculo.forEach(function (tipo) {
                            $tipoVehiculoSelect.append("<option value='" + tipo + "'>" + tipo + "</option>");
                        });
                    },
                    error: function () {
                        console.error("Error al cargar los tipos de vehculo.");
                    }
                });
            }
    
            // Cargar marcas según el tipo de vehículo seleccionado
            $("#id_tipoVehiculo").change(function () {
                limpiarFormulario(); // Limpiar los datos de los campos al cambiar el tipo
                cargarMarcas();
            });
    
            function cargarMarcas() {
                var tipoVehiculoSeleccionado = $("#id_tipoVehiculo").val();
    
                $.ajax({
                    type: "GET",
                    url: "http://localhost:8070/api/vehiculos",
                    success: function (data) {
                        var $marcaSelect = $("#id_marca");
                        $marcaSelect.empty();
                        $marcaSelect.append("<option value=''>Seleccione una marca</option>");
                        var marcasUnicas = new Set();
    
                        $.each(data, function (index, vehiculo) {
                            if (vehiculo.transporte === tipoVehiculoSeleccionado) {  // Se usa 'transporte' para filtrar
                            marcasUnicas.add(vehiculo.marca);
                            }
                        });
    
                        marcasUnicas.forEach(function (marca) {
                            $marcaSelect.append("<option value='" + marca + "'>" + marca + "</option>");
                        });
                    },
                    error: function () {
                        console.error("Error al cargar las marcas.");
                    }
                });
            }
    
            // Cargar modelos según la marca seleccionada
            $("#id_marca").change(function () {
                cargarModelos();
            });
    
            function cargarModelos() {
    var tipoVehiculoSeleccionado = $("#id_tipoVehiculo").val();
    var marcaSeleccionada = $("#id_marca").val();

    $.ajax({
        type: "GET",
        url: "http://localhost:8070/api/vehiculos",
        success: function (data) {
            var $modeloSelect = $("#id_modelo");
            $modeloSelect.empty();
            $modeloSelect.append("<option value=''>Seleccione un modelo</option>");

            $.each(data, function (index, vehiculo) {
                if (vehiculo.transporte === tipoVehiculoSeleccionado && vehiculo.marca === marcaSeleccionada) {
                    // Asegurarse de que 'tipo' se agrega como atributo 'data-tipo'
                    $modeloSelect.append("<option value='" + vehiculo.modelo + "' data-tipo='" + vehiculo.tipo + "'>" + vehiculo.modelo + "</option>");
                }
            });
        },
        error: function () {
            console.error("Error al cargar los modelos.");
        }
    });
}

// Actualizar tipo de vehículo al seleccionar un modelo
$("#id_modelo").change(function () {
    // Obtener el tipo asociado al modelo seleccionado usando el atributo data-tipo
    var tipoSeleccionado = $(this).find(':selected').data('tipo');
    $("#id_tipo").val(tipoSeleccionado);  // Asignar el tipo al campo 'id_tipo'
});

            // Manejo del envío del formulario
            $("#id_registrar").click(function () {
                var validator = $('#id_form').data('bootstrapValidator');
                validator.validate();
    
                if (validator.isValid()) {
                    $("#id_registrar").prop('disabled', true);
                    Swal.fire({
                        title: 'Procesando...',
                        text: 'Por favor espere...',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });
    
                    $.ajax({
                        type: "POST",
                        url: "registraVehiculo",
                        data: new FormData($('#id_form')[0]),
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            Swal.close();
    
                            if (data && data.MENSAJE) {
                                Swal.fire({
                                    title: String.fromCharCode(201) + 'xito',
                                    text: data.MENSAJE,
                                    icon: 'success'
                                });
                            } else if (data && data.ERROR) {
                                Swal.fire({
                                    title: 'Error',
                                    text: data.ERROR,
                                    icon: 'error'
                                });
                            } else {
                                Swal.fire({
                                    title: 'Error',
                                    text: 'Ocurri' + String.fromCharCode(243) + ' un error inesperado.',
                                    icon: 'error'
                                });
                            }
    
                            validator.resetForm();
                            limpiarFormularios();
                        },
                        error: function () {
                            Swal.close();
                            Swal.fire({
                                title: 'Error',
                                text: 'Ocurri' + String.fromCharCode(243) + ' un error al procesar la solicitud.',
                                icon: 'error'
                            });
                        },
                        complete: function () {
                            $("#id_registrar").prop('disabled', false);
                        }
                    });
                } else {
                    Swal.fire({
                        title: 'Advertencia',
                        text: 'Por favor complete todos los campos requeridos.',
                        icon: 'warning'
                    });
                }
            });
    
            // Limpiar formulario
            function limpiarFormulario() {
                $('#id_marca').val('');
                $('#id_modelo').val('');
                $('#id_placa').val('');
                $('#id_tipo').val('');
                $('#id_imagen').val('');
                $('#id_form').data('bootstrapValidator').resetForm(); // Restablecer validación
            }
    
            function limpiarFormularios() {
                $('#id_marca').val('');
                $('#id_modelo').val('');
                $('#id_placa').val('');
                $('#id_tipoVehiculo').val('');
                $('#id_imagen').val('');
                $('#id_form').data('bootstrapValidator').resetForm(); // Restablecer validación
            }
    
            // Validación del formulario con Bootstrap Validator
            $('#id_form').bootstrapValidator({
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    tipoVehiculo: {
                        validators: {
                            notEmpty: {
                                message: 'El tipo de veh' + String.fromCharCode(237) + 'culo es obligatorio'
                            }
                        }
                    },
                    marca: {
                        validators: {
                            notEmpty: {
                                message: 'La marca es obligatoria'
                            }
                        }
                    },
                    modelo: {
                        validators: {
                            notEmpty: {
                                message: 'El modelo es obligatorio'
                            }
                        }
                    },
                    placa: {
                        validators: {
                            notEmpty: {
                                message: 'La placa es requerida'
                            },
                            callback: {
                                message: 'El formato de la placa es incorrecto.',
                                callback: function (value, validator, $field) {
                                    if (!value) return true;
    
                                    var tipoVehiculo = $("#id_tipoVehiculo").val();
                                    var regexCarro = /^[A-Z]{3}-\d{3}$/;
                                    var regexOtro = /^[A-Z]{2}-\d{4}$/;
    
                                    if (tipoVehiculo === "CARRO" && !regexCarro.test(value)) {
                                        return {
                                            valid: false,
                                            message: "La placa debe tener el formato 3 letras - 3 números (ejemplo: ABC-123)."
                                        };
                                    } else if (tipoVehiculo !== "CARRO" && !regexOtro.test(value)) {
                                        return {
                                            valid: false,
                                            message: "La placa debe tener el formato 2 letras - 4 números (ejemplo: AB-1234)."
                                        };
                                    }
                                    return true;
                                }
                            }
                        }
                    },
                    imagen: {
                        validators: {
                            notEmpty: {
                                message: 'La imagen es obligatoria'
                            },
                            file: {
                                type: 'image/jpeg,image/png,image/gif',
                                message: 'El archivo debe ser una imagen'
                            }
                        }
                    }
                }
            });
        });
    </script>
    

</body>

</html>