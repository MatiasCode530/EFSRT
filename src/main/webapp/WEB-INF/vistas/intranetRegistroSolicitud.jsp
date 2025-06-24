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

    <link rel="stylesheet" href="css/bootstrap.css" />
    <link rel="stylesheet" href="css/dataTables.bootstrap.min.css" />
    <link rel="stylesheet" href="css/bootstrapValidator.css" />
    <style>
        /* Estilos para la columna de Estado */
        .estado-activo {
            color: green;
            font-weight: bold;
        }

        .estado-inactivo {
            color: red;
            font-weight: bold;
        }

        /* Estilo para los botones dentro de la tabla */
        .btn-table {
            padding: 5px 10px;
            font-size: 14px;
        }

        .btn-table:hover {
            cursor: pointer;
        }

        /* Estilos para centrar el formulario */
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        body {
            padding-top: 90px;
            /* Altura de la navbar */
        }

        .navbar-fixed-top {
            height: 100px;
            /* Ajusta la altura de tu navbar seg&uacute;n sea necesario */
        }

        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            /* 3 columnas */
            gap: 10px;
            /* Espaciado entre los checkboxes */
        }

        .checkbox-group label {
            display: flex;
            align-items: center;
            border: 1px solid #78b9ff;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .checkbox-reservado {
            background-color: red;
            /* Cambia el fondo a rojo */

        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 10px;
        }

        .checkbox-group label:hover {
            background-color: #076fff;
            /* Color de fondo al pasar el mouse */
        }

        h5 {
            margin-top: 20px;
            /* Espacio arriba de los t&iacute;tulos */
        }

        .espacios-container {
            display: flex;
            justify-content: space-evenly;
            /* Espacio entre los grupos de espacios */
        }
    </style>
    <title>Intranet - Solicitud de Ingreso</title>
</head>

<body>
    <jsp:include page="intranetCabecera.jsp" />
    <div class="container" style="margin-top: 4%">
        <h4>Tus Solicitudes</h4>
    </div>

    <div class="container" style="margin-top: 1%">
        <form id="id_form">
            <div class="row" style="height: 70px">
                <div class="row">

                    <div class="col-md-6" style="display: none;">
                        <input type="hidden" name="idUsuario" value="-">

                        <label class="control-label" for="id_usuario">Espacio</label>
                        <select id="id_usuario" name="paramIdUsuario" class="form-control">
                            <option value="-1">[Todos]</option>
                        </select>
                    </div>
                    <!-- Filtros -->
                    <div class="col-md-6">
                        <label class="control-label" for="id_espacio">Espacio</label>
                        <select id="id_espacio" name="paramEspacio" class="form-control">
                            <option value="-1">[Todos]</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="control-label" for="id_tipoVehiculo">Tipo</label>
                        <select id="id_tipoVehiculo" name="paramtipoVehiculo" class="form-control">
                            <option value="-1">[Todos]</option>
                            <option value="0">Moto</option>
                            <option value="1">Carro</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="control-label" for="id_fechaDesde">Fecha Desde</label>
                        <input class="form-control" type="date" id="id_fechaDesde" name="paramFechaDesde"
                            value="1900-01-01">
                    </div>
                    <div class="col-md-6">
                        <label class="control-label" for="id_fechaHasta">Fecha Hasta</label>
                        <input class="form-control" type="date" id="id_fechaHasta" name="paramFechaHasta"
                            value="2900-01-01">
                    </div>
                    <div class="col-md-6">
                        <label class="control-label" for="id_placa">Placa</label>
                        <input class="form-control" type="text" id="id_placa" name="paramPlaca"
                            placeholder="Ingrese la placa" maxlength="7"
                            pattern="^[A-Za-z]{3}-\d{3}$|^[A-Za-z]{2}-\d{4}$"
                            title="Formato invlido: solo se acepta ABC-123 o AB-1234">
                        <div id="errorPlaca" class="text-danger" style="display: none;"></div> <!-- Mensaje de error -->
                    </div>

                </div>

                <!-- Espacio entre filtros y botones -->
                <div class="row mt-3 text-center">
                    <!-- Botones -->
                    <div class="col-md-2">
                        <button type="button" class="btn btn-primary" id="id_btn_filtra"
                            style="width: 150px">Filtrar</button>
                    </div>
                    <div class="col-md-2">
                        <button type="button" data-toggle="modal" data-target="#id_div_modal_registra"
                            class="btn btn-success" style="width: 150px">REGISTRA</button>
                    </div>
                    <div class="col-md-2">
                        <button type="button" id="id_btn_reporte" class="btn btn-danger">Reporte</button>
                    </div>
                </div>


            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="content">
                        <table id="id_table" class="table table-striped table-bordered table-hover">
                            <thead class="thead-dark">
                                <tr>
                                    <th style="width: 8%">ID</th>
                                    <th style="width: 8%">Nombres</th>
                                    <th style="width: 10%">Marca y modelo</th>
                                    <th style="width: 10%">Tipo Veh&iacute;culo</th>
                                    <th style="width: 05%">N&uacute;mero</th>
                                    <th style="width: 15%">Fecha reserva</th>
                                    <th style="width: 7%">Actualizar</th>
                                    <th style="width: 7%">Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </form>
    </div>


    <!-- Modal para registrar -->
    <div class="modal fade" id="id_div_modal_registra">
        <div class="modal-dialog" style="width: 60%">

            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4><span class="glyphicon glyphicon-ok-sign"></span> Registro de Solicitud</h4>
                </div>
                <div class="modal-body" style="padding: 20px 10px;">
                    <form id="id_form_registra" accept-charset="UTF-8" action="insertaActualizaSolicitud"
                        class="form-horizontal" method="post">
                        <input type="hidden" id="modo" value="registrar"> <!-- Establecer el modo a actualizar -->

                        <div class="panel-group" id="steps">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h4 class="panel-title"><a data-toggle="collapse" data-parent="#steps"
                                            href="#stepOne">Datos de la solicitud</a></h4>
                                </div>
                                <div id="stepOne" class="panel-collapse collapse in">
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <label class="control-label" for="id_reg_vehiculo">Veh&iacute;culo</label>
                                            <select id="id_reg_vehiculo" name="vehiculo" class='form-control' required>
                                                <option value="">[Seleccione]</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label class="control-label" for="id_reg_fecha_reserva">Fecha
                                                Reserva</label>
                                            <input class="form-control" type="date" id="id_reg_fecha_reserva"
                                                name="fechaReserva" required>
                                        </div>

                                        <div class="form-group">
                                            <label class="control-label" for="id_reg_hora">Hora</label>
                                            <input class="form-control" type="time" id="id_reg_hora" name="hora"
                                                required>
                                        </div>

                                        <label class="control-label" for="id_reg_Espacios">Espacios</label>
                                    </div>
                                </div>
                                <div class="espacios-container" style="margin-top: -30px;">
                                    <div>
                                        <h5>Pabell&oacute;n A - Piso 1</h5>
                                        <div class="checkbox-group" id="espacios1Checkboxes">
                                            <!-- Los checkboxes del Pabell &oacute;n E - 1 se agregar &aacute;n din &aacute;micamente aquí -->
                                        </div>
                                    </div>
                                    <div>
                                        <h5>Pabell&oacute;n E - Piso SS</h5>
                                        <div class="checkbox-group" id="espaciosSSCheckboxes">
                                            <!-- Los checkboxes del Pabell &oacute;n E - SS se agregar &aacute;n din &aacute;micamente aquí -->
                                        </div>
                                    </div>
                                    <div>
                                        <h5>Pabell&oacute;n E - Piso S1</h5>
                                        <div class="checkbox-group" id="espaciosS1Checkboxes">
                                            <!-- Los checkboxes del Pabell &oacute;n E - S1 se agregar &aacute;n din &aacute;micamente aquí -->
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-lg-9 col-lg-offset-3">
                                        <button type="button" class="btn btn-primary"
                                            id="id_registrar">REGISTRA</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


    <!-- Modal para actualizar -->
    <div class="modal fade" id="id_div_modal_actualiza">
        <div class="modal-dialog" style="width: 60%">
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4><span class="glyphicon glyphicon-ok-sign"></span> Actualizaci&oacute;n de Solicitud</h4>
                </div>
                <div class="modal-body" style="padding: 20px 10px;">
                    <form id="id_form_actualiza" accept-charset="UTF-8" action="insertaActualizaSolicitud"
                        class="form-horizontal" method="post">
                        <input type="hidden" id="modo" value="actualizar"> <!-- Establecer el modo a actualizar -->
                        <div class="panel-group" id="steps">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h4 class="panel-title"><a data-toggle="collapse" data-parent="#steps"
                                            href="#stepUpdate">Datos de la solicitud</a></h4>
                                </div>
                                <div id="stepUpdate" class="panel-collapse collapse in">
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <label class="col-lg-3 control-label" for="id_ID">ID</label>
                                            <div class="col-lg-6">
                                                <input class="form-control" id="id_ID" readonly="readonly"
                                                    name="idSolicitud" type="text" maxlength="8" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="id_act_vehiculo">Veh&iacute;culo</label>
                                            <select id="id_act_vehiculo" name="vehiculo" class='form-control' required>
                                                <option value="">[Seleccione]</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label class="control-label" for="id_act_fecha_reserva">Fecha
                                                Reserva</label>
                                            <input class="form-control" type="date" id="id_act_fecha_reserva"
                                                name="fechaReserva" required>
                                        </div>


                                        <div class="form-group">
                                            <label class="control-label" for="id_act_hora">Hora</label>
                                            <input class="form-control" type="time" id="id_act_hora" name="hora"
                                                required>
                                        </div>

                                        <label class="control-label" for="id_Espacios">Espacios</label>
                                    </div>
                                </div>
                                <div class="espacios-container" style="margin-top: 30px;">
                                    <div>
                                        <h5>Pabell&oacute;n A - Piso 1</h5>
                                        <div class="checkbox-group" id="espacios1CheckboxesActualiza">
                                            <!-- Los checkboxes del Pabell &oacute;n E - 1 se agregar &aacute;n din &aacute;micamente aquí -->
                                        </div>
                                    </div>
                                    <div>
                                        <h5>Pabell&oacute;n E - Piso SS</h5>
                                        <div class="checkbox-group" id="espaciosSSCheckboxesActualiza">
                                            <!-- Los checkboxes del Pabellón E - SS se agregarán dinámicamente aquí -->
                                        </div>
                                    </div>
                                    <div>
                                        <h5>Pabell&oacute;n E - Piso S1</h5>
                                        <div class="checkbox-group" id="espaciosS1CheckboxesActualiza">
                                            <!-- Los checkboxes del Pabellón E - S1 se agregarán dinámicamente aquí -->
                                        </div>
                                    </div>


                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-lg-9 col-lg-offset-3">
                                    <button type="button" class="btn btn-primary"
                                        id="id_btn_actualiza">ACTUALIZA</button>
                                </div>
                            </div>
                        </div>
                </div>
                </form>
            </div>
        </div>
    </div>






    </div>



    </div>
    <script type="text/javascript">

        // Obtener el formulario y el botón de filtrar
        const form = document.querySelector("id_form");
        const filtrarBtn = document.getElementById("id_btn_filtra");
        const placaInput = document.getElementById("id_placa");
        const errorPlaca = document.getElementById("errorPlaca");

        // Añadir evento al botón de filtrar
        filtrarBtn.addEventListener("click", function (event) {
            // Prevenir el envío del formulario por defecto
            event.preventDefault();

            // Verificar si el campo de la placa es nulo o vacío
            if (placaInput.value.trim() === "") {
                errorPlaca.style.display = "none"; // Si está vacío, no mostrar el mensaje de error
                form.submit(); // Enviar el formulario si está vacío
            } else {
                // Verificar si el campo de la placa es válido según el patrón
                if (placaInput.checkValidity()) {
                    errorPlaca.style.display = "none"; // Si es válido, ocultar el mensaje de error
                    form.submit(); // Enviar el formulario si es válido
                } else {
                    errorPlaca.textContent = placaInput.title; // Mostrar el mensaje de error
                    errorPlaca.style.display = "block"; // Hacer visible el mensaje de error
                }
            }
        });
        // Obtener los campos de fecha
        const fechaInput1 = document.getElementById('id_reg_fecha_reserva');
        const fechaInput2 = document.getElementById('id_act_fecha_reserva');

        // Obtener la fecha actual en formato YYYY-MM-DD
        const today = new Date();
        const todayString = today.toISOString().split('T')[0]; // Formato YYYY-MM-DD

        // Obtener la fecha de mañana
        const tomorrow = new Date(today.getTime() + 24 * 60 * 60 * 1000); // 24 horas más
        const tomorrowString = tomorrow.toISOString().split('T')[0]; // Formato YYYY-MM-DD

        // Establecer los atributos min y max en los campos de fecha
        fechaInput1.min = todayString;
        fechaInput1.max = tomorrowString;

        fechaInput2.min = todayString;
        fechaInput2.max = tomorrowString;

        var idUsuario = <%= (session.getAttribute("idUsuario") != null) ? session.getAttribute("idUsuario") : 0 %>; // Definir idUsuario desde la sesi&oacute;n
        console.log("El idUsuario es:", idUsuario);

        // Cambiar el valor del <select> con el idUsuario obtenido
        if (idUsuario !== 0) {
            var selectElement = document.getElementById("id_usuario");
            var option = document.createElement("option");
            option.value = idUsuario;
            option.text = "Usuario " + idUsuario; // Puedes cambiar el texto según lo necesites
            selectElement.appendChild(option);
            selectElement.value = idUsuario; // Establecer el valor seleccionado
        }
        $(document).ready(function () {
            // Cargar datos solo una vez al inicio
            $('#id_reg_hora').prop('disabled', true);

            // Evento para habilitar/deshabilitar el campo de hora cuando se selecciona una fecha en id_reg_fechaReserva
            $('#id_reg_fecha_reserva').change(function () {
                if ($(this).val()) {
                    $('#id_reg_hora').prop('disabled', false); // Habilitar el campo de hora correspondiente
                } else {
                    $('#id_reg_hora').prop('disabled', true); // Deshabilitar si no hay fecha seleccionada
                }
            });

            actualizarComboBox();


            $("#id_registrar").click(function () {
                var modo = $('#modo').val(); // 'registrar' o 'actualizar'
                var validator = $('#id_form_registra').data('bootstrapValidator');
                validator.validate();

                if (validator.isValid()) { // Verifica si el formulario es válido
                    var espaciosSeleccionados = [];
                    $('input[name="espacio"]:checked').each(function () {
                        espaciosSeleccionados.push($(this).val());
                    });

                    // Agregar espacios seleccionados a los datos que se envían
                    $.ajax({
                        type: "POST",
                        url: "registraSolicitud", // Cambiar a la URL correspondiente
                        data: $('#id_form_registra').serialize() + "&espacios=" + espaciosSeleccionados.join(','),
                        success: function (data) {
                            mostrarMensaje(data.MENSAJE);
                            limpiarFormulario(); // Limpiar y actualizar ComboBox
                            validator.resetForm();
                            actualizarComboBox()

                            $('#id_div_modal_registra').modal('hide');

                        },
                        error: function () {
                            mostrarMensaje("Error en la reserva. Int" + String.fromCharCode(233) + "ntalo de nuevo.");
                        }
                    });
                }
            });
            $("#id_btn_actualiza").click(function () {
                var modo = $('#modo').val(); // 'registrar' o 'actualizar'
                var validator = $('#id_form_actualiza').data('bootstrapValidator');
                validator.validate();

                if (validator.isValid()) { // Verifica si el formulario es válido
                    var espaciosSeleccionados = [];
                    $('input[name="espacio"]:checked').each(function () {
                        espaciosSeleccionados.push($(this).val()); // Este valor debe ser el ID del espacio
                    });

                    $.ajax({
                        type: "POST",
                        url: "actualizaSolicitud", // Cambiar a la URL correspondiente para actualizar
                        data: $('#id_form_actualiza').serialize() + "&espacio=" + espaciosSeleccionados.join(','),
                        success: function (data) {
                            mostrarMensaje(data.MENSAJE);
                            validator.resetForm();
                            actualizarComboBox()
                            // Cerrar el modal después de la actualización
                            $('#id_div_modal_actualiza').modal('hide');
                                // Simula un clic en el botón con ID "id_filtrar"
                $("#id_btn_filtra").click();
                        },
                        error: function () {
                            mostrarMensaje("Error en la actualizaci" + String.fromCharCode(243) + "n. Int" + String.fromCharCode(233) + "ntalo de nuevo.");
                        }
                    });
                }
            });
        });
        function editar(idSolicitud, vehiculo, hora, fechaReserva, numero) {

            // Asigna los valores a los campos del modal de actualización
            $('#id_ID').val(idSolicitud);
            $('#id_act_vehiculo').val(vehiculo);
            $('#id_act_hora').val(hora);
            $('#id_act_fecha_reserva').val(fechaReserva);
            actualizarComboBox(vehiculo); // Pasa el vehículo a seleccionar

            // Cargar los vehículos y seleccionar el correspondiente

            // Muestra el modal de actualización
            $('#id_div_modal_actualiza').modal("show");
        }
        function detalles(idSolicitud, vehiculo, hora, fechaReserva, numero) {

            // Asigna los valores a los campos del modal de actualización
            $('#id_ID').val(idSolicitud);
            $('#id_act_vehiculo').val(vehiculo);
            $('#id_act_hora').val(hora);
            $('#id_act_fechaReserva').val(fechaReserva);


            // Cargar los vehículos y seleccionar el correspondiente
            actualizarComboBox(vehiculo); // Pasa el vehículo a seleccionar

            // Muestra el modal de actualización
            $('#id_div_modal_detalle').modal("show");
        }

        function limpiarFormulario() {
            $('#id_form_registra')[0].reset();
            $('#id_form_actualiza')[0].reset();

            actualizarComboBox(); // Refresca las listas, pero solo después de limpiar el formulario
        }


        function actualizarComboBox(vehiculo) {
            // Limpieza inicial
            $("#espaciosS1CheckboxesActualiza").empty();
            $("#espaciosSSCheckboxesActualiza").empty();
            $("#espacios1CheckboxesActualiza").empty();
            $("#espaciosS1Checkboxes").empty();
            $("#espaciosSSCheckboxes").empty();
            $("#espacios1Checkboxes").empty();
            $("#id_reg_vehiculo").empty().append("<option value=''>[Seleccione]</option>");
            $("#id_act_vehiculo").empty().append("<option value=''>[Seleccione]</option>");

            // Obtener la lista de vehículos del usuario y agregar al select
            $.getJSON("listaVehiculosUsuario/" + idUsuario, {}, function (data) {
                // Limpiar y llenar los select de vehículos
                $("#id_reg_vehiculo").empty().append("<option value=''>[Seleccione]</option>");
                $("#id_act_vehiculo").empty().append("<option value=''>[Seleccione]</option>");

                $.each(data, function (index, item) {
                    var marcavehiculo = item.marca + " " + item.modelo;
                    var tipoVehiculo = item.tipoVehiculo;
                    var discapacitado = item.usuarioRegistro.discapacitado;

                    $("#id_reg_vehiculo").append("<option value='" + item.idVehiculo + "' data-tipo='" + tipoVehiculo + "' data-disco='" + discapacitado + "'>" + marcavehiculo + "</option>");
                    $("#id_act_vehiculo").append("<option value='" + item.idVehiculo + "' data-tipo='" + tipoVehiculo + "' data-disco='" + discapacitado + "'>" + marcavehiculo + "</option>");
                });

                if (vehiculo) {
                    $('#id_act_vehiculo').val(vehiculo);
                }

                // Detectar cambio en el select de vehículo
                $("#id_reg_vehiculo, #id_act_vehiculo").on("change", function () {
                    var tipoVehiculoSeleccionado = $("option:selected", this).attr("data-tipo");
                    var discapacitadoSeleccionado = $("option:selected", this).attr("data-disco");

                    // Limpiar checkboxes antes de llenarlos
                    $("#espaciosS1Checkboxes").empty();
                    $("#espaciosSSCheckboxes").empty();
                    $("#espacios1Checkboxes").empty();
                    $("#espaciosS1CheckboxesActualiza").empty();
                    $("#espaciosSSCheckboxesActualiza").empty();
                    $("#espacios1CheckboxesActualiza").empty();

                    // Obtener lista de espacios
                    $.getJSON("listaEspacios", {}, function (data) {
                        var espaciosSS = [];
                        var espaciosS1 = [];
                        var espacios1 = [];

                        // Clasificar espacios
                        $.each(data, function (index, item) {
                            if (item.piso === "SS") {
                                espaciosSS.push(item);
                            } else if (item.piso === "S1") {
                                espaciosS1.push(item);
                            } else if (item.piso === "1") {
                                espacios1.push(item);
                            }
                        });

                        // Llenar espacios según tipo de vehículo
                        if (tipoVehiculoSeleccionado === "CARRO") {
                            llenarEspacios("#espaciosSSCheckboxes", espaciosSS, discapacitadoSeleccionado);
                            llenarEspacios("#espaciosS1Checkboxes", espaciosS1, discapacitadoSeleccionado);
                        } else if (tipoVehiculoSeleccionado === "MOTO") {
                            llenarEspacios("#espacios1Checkboxes", espacios1);
                        }

                        // Evitar duplicados en los checkboxes de actualización
                        if (tipoVehiculoSeleccionado === "CARRO") {
                            llenarEspacios("#espaciosSSCheckboxesActualiza", espaciosSS, discapacitadoSeleccionado);
                            llenarEspacios("#espaciosS1CheckboxesActualiza", espaciosS1, discapacitadoSeleccionado);
                        } else if (tipoVehiculoSeleccionado === "MOTO") {
                            llenarEspacios("#espacios1CheckboxesActualiza", espacios1);
                        }
                    });
                });
            });
        }

        function llenarEspacios(selector, espacios, discapacitado = null, estado_reserva = null, esActualizacion = false) {
            // Limpia el contenedor antes de llenarlo para evitar duplicados
            $(selector).empty();
            $.each(espacios, function (index, item) {
                var disabledAttribute = '';
                var disabledClass = '';
                var labelStyle = ''; // Variable para aplicar estilo al label
                // Validación del estado de reserva
                if (item.estado_reserva === 1) {
                    if (estado_reserva !== null && item.idEspacio === parseInt(estado_reserva)) {
                        // El espacio es el reservado por el usuario, debe estar habilitado solo en la actualización
                        if (esActualizacion) {
                            disabledAttribute = '';
                            disabledClass = '';
                            labelStyle = ''; // Sin estilo especial, se habilita normalmente
                        } else {
                            // El espacio reservado no debe aparecer disponible para nuevas solicitudes
                            disabledAttribute = 'disabled';
                            disabledClass = 'disabled-red'; // Aplicando la clase disabled-red para fondo rojo
                            labelStyle = 'background-color: red; color: white;'; // Estilo en línea para el label
                        }
                    } else {
                        // El espacio está ocupado y no corresponde al usuario
                        disabledAttribute = 'disabled';
                        disabledClass = 'disabled-red'; // Aplicando la clase disabled-red para fondo rojo
                        labelStyle = 'background-color: red; color: white;'; // Estilo en línea para el label
                    }
                } else if (item.estado_reserva === 0) {
                    // Espacio libre, habilitarlo
                    disabledAttribute = '';
                    disabledClass = '';
                    labelStyle = ''; // Sin estilo, se deja habilitado
                }
                // Validación de discapacitado
                if (discapacitado === "0" && (item.numero === "1" || item.numero === "4")) {
                    disabledAttribute = 'disabled';
                    disabledClass = 'disabled-red'; // Aplicando la clase disabled-red para fondo rojo
                    labelStyle = 'background-color: red; color: white;'; // Estilo en línea para el label
                }
                // Agregar el checkbox al contenedor con los estilos in-line aplicados al label
                $(selector).append("<label style='" + labelStyle + "'><input type='checkbox' name='espacio' value='" + item.idEspacio + "' " + disabledAttribute + " class='" + disabledClass + "'> " + item.numero + "</label>");
            });
            // Solo permitir un checkbox seleccionado
            $("input[name='espacio']").on("change", function () {
                $("input[name='espacio']").not(this).prop("checked", false);
            });
        }




        $('#id_form_actualiza').bootstrapValidator({
            message: 'Este valor no es v&aacute;lido',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                vehiculo: {
                    validators: {
                        notEmpty: {
                            message: 'Seleccione un veh&iacute;culo.'
                        }
                    }
                },
                hora: {
                    validators: {
                        notEmpty: {
                            message: 'La hora es obligatoria.'
                        },
                        callback: {
                            message: 'La hora debe estar entre 07:00 am y 8:00 pm.',
                            callback: function (value, validator) {
                                var fechaReserva = $('#id_act_fecha_reserva').val();
                                if (!fechaReserva) {
                                    return {
                                        valid: false,
                                        message: 'No se puede validar la hora sin una fecha.'
                                    }; // Retorna el mensaje específico si no hay fecha
                                }

                                var fechaCompleta = new Date(fechaReserva + "T" + value + ":00");
                                var minHora = new Date(fechaReserva + "T07:00:00");
                                var maxHora = new Date(fechaReserva + "T20:00:00"); // 8:00 pm

                                // Validar que la hora no sea menor a la hora actual, ignorando segundos
                                var fechaActual = new Date();
                                fechaActual.setSeconds(0);
                                fechaActual.setMilliseconds(0);

                                if (fechaCompleta < fechaActual) {
                                    return {
                                        valid: false,
                                        message: 'La hora seleccionada (' + value + ') es anterior a la hora actual.'
                                    }; // Retorna un mensaje dinámico si es menor a la hora actual
                                }

                                // Validar que la hora esté entre el rango permitido
                                if (fechaCompleta < minHora || fechaCompleta > maxHora) {
                                    return {
                                        valid: false,
                                        message: 'La hora debe estar entre 07:00 am y 8:00 pm.'
                                    }; // Retorna el mensaje de rango
                                }

                                return true; // La validación pasa
                            }
                        }
                    }
                },

                fechaReserva: {
                    validators: {
                        notEmpty: {
                            message: 'La fecha de reserva es obligatoria.'
                        }
                    }
                }
            }
        });

        $('#id_form_registra').bootstrapValidator({
            message: 'Este valor no es v&aacute;lido',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                vehiculo: {
                    validators: {
                        notEmpty: {
                            message: 'Seleccione un veh&iacute;culo.'
                        }
                    }
                },
                hora: {
                    validators: {
                        notEmpty: {
                            message: 'La hora es obligatoria.'
                        },
                        callback: {
                            message: 'La hora debe estar entre 07:00 am y 8:00 pm.',
                            callback: function (value, validator) {
                                var fechaReserva = $('#id_reg_fecha_reserva').val();
                                if (!fechaReserva) {
                                    return {
                                        valid: false,
                                        message: 'No se puede validar la hora sin una fecha.'
                                    }; // Retorna el mensaje específico si no hay fecha
                                }

                                var fechaCompleta = new Date(fechaReserva + "T" + value + ":00");
                                var minHora = new Date(fechaReserva + "T07:00:00");
                                var maxHora = new Date(fechaReserva + "T20:00:00"); // 8:00 pm

                                // Validar que la hora no sea menor a la hora actual, ignorando segundos
                                var fechaActual = new Date();
                                fechaActual.setSeconds(0);
                                fechaActual.setMilliseconds(0);

                                if (fechaCompleta < fechaActual) {
                                    return {
                                        valid: false,
                                        message: 'La hora seleccionada (' + value + ') es anterior a la hora actual.'
                                    }; // Retorna un mensaje dinámico si es menor a la hora actual
                                }

                                // Validar que la hora esté entre el rango permitido
                                if (fechaCompleta < minHora || fechaCompleta > maxHora) {
                                    return {
                                        valid: false,
                                        message: 'La hora debe estar entre 07:00 am y 8:00 pm.'
                                    }; // Retorna el mensaje de rango
                                }

                                return true; // La validación pasa
                            }
                        }
                    }
                },

                fechaReserva: {
                    validators: {
                        notEmpty: {
                            message: 'La fecha de reserva es obligatoria.'
                        }
                    }
                }
            }
        });




        // Cargar lista de espacios
        $.getJSON("listaEspacios", {}, function (data) {
            console.log("Datos recibidos:", data);

            // Ordenar los datos por pabellón, priorizando "Pabellón A" y "Pabellón E"
            const ordenPabellones = ["Pabellón A", "Pabellón E"];

            // Ordenar los elementos
            data.sort(function (a, b) {
                // Si el pabellón no está en el orden, ponerlo al final
                const indexA = ordenPabellones.includes(a.pabellon) ? ordenPabellones.indexOf(a.pabellon) : Infinity;
                const indexB = ordenPabellones.includes(b.pabellon) ? ordenPabellones.indexOf(b.pabellon) : Infinity;

                // Ordenar por el índice del pabellón, aquellos que no están en la lista irán al final
                return indexA - indexB;
            });

            // Iterar sobre los datos ordenados y agregarlos al <select>
            $.each(data, function (i, item) {
                $("#id_espacio").append("<option value='" + item.idEspacio + "'>" + item.pabellon + "---- " + "Estacionamiento " + item.numero + "</option>");
            });
        });



        // Manejo de reporte
        $("#id_btn_reporte").click(function () {
            $("#id_form").attr('action', 'reporteSolicitudPdf');
            $("#id_form").submit();
        });

        // Filtrar datos
        $("#id_btn_filtra").click(function () {
            var varEstado = $("#id_estado").is(':checked') ? 1 : 0;
            var varEspacio = $("#id_espacio").val();
            var varUsuario = $("#id_usuario").val();
            var varPlaca = $("#id_placa").val();
            var vartipoVehiculo = $("#id_tipoVehiculo").val(); // Tipo de veh&iacute;culo
            var varFechaDesde = $("#id_fechaDesde").val() || '1900-01-01';
            var varFechaHasta = $("#id_fechaHasta").val() || '2900-01-01';


            // Validar fechas
            if (new Date(varFechaDesde) > new Date(varFechaHasta)) {
                alert("La fecha hasta no puede ser menor que la fecha desde");
                return;
            }

            $.getJSON("consultaSolicitud", {
                "idEspacio": varEspacio,
                "placa": varPlaca,
                "idUsuario": varUsuario,
                "tipoVehiculo": vartipoVehiculo, // Par&aacute;metro correcto
                "fecDesde": varFechaDesde,
                "fecHasta": varFechaHasta
            }, function (data) {
                agregarGrilla(data);
            });
        });


        function agregarGrilla(lista) {
            // Filtrar la lista para incluir solo registros con estado "Inactivo" (estado = 0)
            var listaFiltrada = lista.filter(function (row) {
                return row.estadoEspecial === 0

            });

            // Verificar si DataTable ya existe
            if ($.fn.DataTable.isDataTable('#id_table')) {
                $('#id_table').DataTable().clear().destroy();
            }

            $('#id_table').DataTable({
                data: listaFiltrada,
                searching: false,
                ordering: true,
                processing: true,
                pageLength: 10,
                lengthChange: false,
                columns: [
                    { data: "idSolicitud" },
                    { data: "usuarioRegistro.nombres" },
                    {
                        data: function (row) {
                            return row.vehiculo.marca + ' ' + row.vehiculo.modelo; // Combina marca y modelo
                        },
                        className: 'text-center'
                    },
                    {
                        data: function (row) {
                            return row.vehiculo.tipoVehiculo; // Retorna directamente el valor MOTO o CARRO
                        },
                        className: 'text-center'
                    },
                    { data: "espacio.numero" },
                    {
                        data: function (row) {
                            return row.hora + ' ' + row.fechaReserva;
                        },
                        className: 'text-center'
                    },
                    {
                        data: function (row) {
                            // Verificar si el estado de la solicitud es 0
                            var botonEditar = row.estado === 0 ?
                                // Si el estado es 0, deshabilitar el botón
                                '<button type="button" class="btn btn-info btn-sm" disabled>Editar</button>' :
                                // Si el estado es diferente de 0, habilitar el botón
                                '<button type="button" class="btn btn-info btn-sm" onclick="editar(\'' + row.idSolicitud + '\', \'' + row.vehiculo.idVehiculo + '\', \'' + row.hora + '\', \'' + row.fechaReserva + '\', \'' + row.espacio.idEspacio + '\')">Editar</button>';

                            return botonEditar;
                        },
                        className: 'text-center'
                    },
                    {
                        data: function (row) {
                            return (row.estado == 1) ? 'Activo' : 'Finalizado';
                        },
                        className: 'text-center'
                    }
                ],
                order: [[6, 'desc']]  // Esto ordenará la columna "estado" de mayor (1) a menor (0)

            });
        }
        function registrarEntrada(idSolicitud) {
            $.ajax({
                url: 'registrarEntradaSalida',
                type: 'POST',
                data: {
                    "idSolicitud": idSolicitud, // ID de la solicitud
                    accion: 'entrada' // Tipo de acción a realizar
                },
                success: function (data) {
                    mostrarMensaje(data.MENSAJE);  // Aquí se está accediendo a la clave "MENSAJE" de la respuesta
                    actualizarComboBox()
                    $('#id_btn_filtra').click();    // Activa el botón de filtro automáticamente


                },
                error: function () {
                    mostrarMensaje("Error al registrar entrada: "); // Mensaje de error
                }
            });
        }

        // Función para registrar salida
        function registrarSalida(idSolicitud) {
            $.ajax({
                type: 'POST',
                url: 'registrarEntradaSalida',
                data: {
                    "idSolicitud": idSolicitud, // ID de la solicitud
                    accion: 'salida' // Tipo de acción a realizar
                },
                success: function (data) {
                    mostrarMensaje(data.MENSAJE);  // Aquí se está accediendo a la clave "MENSAJE" de la respuesta
                    actualizarComboBox()
                    $('#id_btn_filtra').click();    // Activa el botón de filtro automáticamente


                },
                error: function () {
                    mostrarMensaje("Error al registrar salida: "); // Mensaje de error
                }
            });
        }


    </script>
</body>

</html>