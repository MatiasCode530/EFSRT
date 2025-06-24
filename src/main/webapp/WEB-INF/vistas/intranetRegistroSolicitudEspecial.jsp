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

    <link rel="stylesheet" href="css/bootstrap.css" />
    <link rel="stylesheet" href="css/dataTables.bootstrap.min.css" />
    <link rel="stylesheet" href="css/bootstrapValidator.css" />

    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery.dataTables.min.js"></script>
    <script src="js/dataTables.bootstrap.min.js"></script>
    <script src="js/bootstrapValidator.js"></script>
    <script src="js/global.js"></script>

    <style>
        body {
            padding-top: 90px;
            /* Altura de la navbar */
        }

        .navbar-fixed-top {
            height: 100px;
            /* Ajusta la altura de tu navbar seg&uacute;n sea necesario */
        }

        .form-row {
            display: flex;
            justify-content: space-between;
            /* Espacio entre los elementos */
            margin-bottom: 15px;
            /* Espacio entre filas del formulario */
        }

        .form-column {
            flex: 1;
            margin-right: 10px;
            /* Espacio entre las columnas */
        }

        .form-column:last-child {
            margin-right: 0;
            /* Sin margen derecho en la &uacute;ltima columna */
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
            border: 1px solid #007bff;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 10px;
        }

        .checkbox-group label:hover {
            background-color: #e7f1ff;
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

    <title>Reserva de Espacios</title>
</head>

<body>
    <jsp:include page="intranetCabecera.jsp" />

    <div class="container" style="margin-top: 4%">
        <h4>Reserva de Espacios</h4>
    </div>

    <div class="container" style="margin-top: 1%">
        <form id="id_form" method="post">
            <div class="form-row">
                <div class="form-column">
                    <div class="form-group">
                        <label class="control-label" for="id_vehiculo">Veh&iacute;culo</label>
                        <select id="id_vehiculo" name="vehiculo" class='form-control' required>
                            <option value="">[Seleccione]</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="id_fecha_reserva">Fecha Reserva</label>
                        <input class="form-control" type="date" id="id_fecha_reserva" name="fechaReserva" required
                            min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                    </div>
                    
                    <div class="form-group">
                        <label class="control-label" for="id_hora">Hora</label>
                        <input class="form-control" type="time" id="id_hora" name="hora" required>
                    </div>


                    <label class="control-label" for="id_Espacios">Espacios</label>
                </div>
            </div>

            <!-- Secci&oacute;n de Pabellones -->
            <div class="espacios-container" style="margin-top: 20px;">
                <div>
                    <h5>Pabell&oacute;n E - Piso SS</h5>
                    <div class="checkbox-group" id="espaciosSSCheckboxes">
                        <!-- Los checkboxes del Pabell&oacute;n E - SS se agregar&aacute;n din&aacute;micamente aqu&iacute; -->
                    </div>
                </div>
                <div>
                    <h5>Pabell&oacute;n E - Piso S1</h5>
                    <div class="checkbox-group" id="espaciosS1Checkboxes">
                        <!-- Los checkboxes del Pabell&oacute;n E - S1 se agregar&aacute;n din&aacute;micamente aqu&iacute; -->
                    </div>
                </div>
            </div>
            <!-- Fin de Secci&oacute;n de Pabellones -->

            <div class="row">
                <div class="form-group col-md-12" align="center">
                    <button id="id_registrar" type="button" class="btn btn-primary">Registrar Reserva</button>
                </div>
            </div>
        </form>
    </div>

    <script type="text/javascript">
        var idUsuario = <%= (session.getAttribute("idUsuario") != null) ? session.getAttribute("idUsuario") : 0 %>; // Definir idUsuario desde la sesi&oacute;n
        console.log("ID de Usuario:", idUsuario); // Imprimir el idUsuario en la consola


        $(document).ready(function () {
            actualizarComboBox(); // Cargar datos solo una vez al inicio
            // Evento para habilitar el campo de hora cuando se selecciona una fecha
            // Inicialmente deshabilitar el campo de hora
            $('#id_hora').prop('disabled', true);

            // Evento para habilitar el campo de hora cuando se selecciona una fecha
            $('#id_fecha_reserva').change(function () {
                if ($(this).val()) {
                    $('#id_hora').prop('disabled', false); // Habilitar el campo de hora
                } else {
                    $('#id_hora').prop('disabled', true); // Deshabilitar si no hay fecha seleccionada
                }
            });
            $("#id_registrar").click(function () {
                var validator = $('#id_form').data('bootstrapValidator');
                validator.validate();

                if (validator.isValid()) { // Verifica si el formulario es v&aacute;lido
                    var espaciosSeleccionados = [];
                    $('input[name="espacio"]:checked').each(function () {
                        espaciosSeleccionados.push($(this).val());

                    });

                    // Agregar espacios seleccionados a los datos que se env&iacute;an
                    $.ajax({
                        type: "POST",
                        url: "registraSolicitud", // Cambiar a la URL correspondiente
                        data: $('#id_form').serialize() + "&espacios=" + espaciosSeleccionados.join(','),
                        success: function(data) {
                            mostrarMensaje(data.MENSAJE);
                            limpiarFormulario(); // Limpiar y actualizar ComboBox
                            validator.resetForm();
                        },
                        error: function() {
                            mostrarMensaje("Error en la reserva. Inténtalo de nuevo.");
                        }
                    });
                }
            });
        });



        function limpiarFormulario() {
            $('#id_form')[0].reset();
            actualizarComboBox(); // Refresca las listas, pero solo despu&eacute;s de limpiar el formulario
        }

        function actualizarComboBox() {
            // Limpiar las listas de checkboxes y el select de vehículos
            $("#espaciosS1Checkboxes").empty(); // Limpiar los checkboxes S1
            $("#espaciosSSCheckboxes").empty(); // Limpiar los checkboxes SS
            $("#id_vehiculo").empty(); // Limpiar el select de vehículos
            $("#id_vehiculo").append("<option value=''>[Seleccione]</option>"); // Opción predeterminada

            // Obtener la lista de espacios
            $.getJSON("listaEspacio", {}, function (data) {
                var espaciosSS = [];
                var espaciosS1 = [];

                // Separar espacios según el pabellón y piso
                $.each(data, function (index, item) {
                    if (item.piso === "SS") {
                        espaciosSS.push(item);
                    } else if (item.piso === "S1") {
                        espaciosS1.push(item);
                    }
                });

                // Agregar checkboxes para Pabellón E, Piso SS
                if (espaciosSS.length > 0) {
                    $.each(espaciosSS, function (index, item) {
                        $("#espaciosSSCheckboxes").append(
                            "<label><input type='checkbox' name='espacio' value='" + item.idEspacio + "'> " + item.numero + "</label>"
                        );
                    });
                }

                // Agregar checkboxes para Pabellón E, Piso S1
                if (espaciosS1.length > 0) {
                    $.each(espaciosS1, function (index, item) {
                        $("#espaciosS1Checkboxes").append(
                            "<label><input type='checkbox' name='espacio' value='" + item.idEspacio + "'> " + item.numero + "</label>"
                        );
                    });
                }

                // Evento para permitir solo una selección entre todos los checkboxes
                $("input[name='espacio']").on("change", function () {
                    $("input[name='espacio']").not(this).prop("checked", false);
                });
            });

            // Cargar vehículos del usuario y agregar al select
            $.getJSON("listaVehiculosUsuario/" + idUsuario, {}, function (data) {
                $.each(data, function (index, item) {
                    var marcavehiculo = item.marca + " " + item.modelo;
                    $("#id_vehiculo").append("<option value='" + item.idVehiculo + "'>" + marcavehiculo + "</option>");
                });
            });
        }


        $('#id_form').bootstrapValidator({
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
                                var fechaReserva = $('#id_fecha_reserva').val();
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
        $('#id_hora').on('change', function () {
            $('#id_form').bootstrapValidator('revalidateField', 'hora');
        });
        function validarFechaHora() {
            var fechaReserva = $('#id_fecha_reserva').val();
            var horaReserva = $('#id_hora').val();

            if (fechaReserva && horaReserva) {
                var fechaActual = new Date();
                var fechaReservaActual = new Date(fechaReserva + 'T' + horaReserva + ':00');

                if (fechaReservaActual < fechaActual) {
                    return false; // La hora es inválida
                }
            }
            return true; // La validación es correcta
        }
    </script>
</body>

</html>