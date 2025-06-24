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
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/global.js"></script>
    <!-- SweetAlert2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.6.0/dist/sweetalert2.min.css" rel="stylesheet">

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.6.0/dist/sweetalert2.all.min.js"></script>

    <link rel="stylesheet" href="css/bootstrap.css" />

    <title>Registro de Incidencia</title>

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

        .usuario-involucrado-group {
            margin-bottom: 15px;
        }

        .usuario-involucrado-group select {
            width: calc(100% - 50px);
            display: inline-block;
        }

        .btn-add-user {
            display: inline-block;
            margin-left: 10px;
            cursor: pointer;
        }
    </style>
</head>

<body>
    <jsp:include page="intranetCabecera.jsp" />

    <div class="container">
        <div class="form-container">
            <h4>Registro de incidencia</h4>
            <form id="id_form" method="post" enctype="multipart/form-data">

                <!-- Usuarios Involucrados -->
                <div id="usuariosInvolucradosContainer">
                    <div class="form-group usuario-involucrado-group">
                        <label class="control-label" for="id_usuariosInvolucrados">Usuarios Involucrados</label>
                        <select class="form-control" name="idUsuarios[]" required>
                            <option value="">Seleccione un Usuario</option>
                            <!-- Las opciones se llenarán aquí mediante AJAX -->
                        </select>
                        <span class="btn-add-user btn btn-success">+</span>
                    </div>
                </div>

                <!-- Descripción -->
                <div class="form-group">
                    <label class="control-label" for="id_descripcion">Descripci&oacute;n</label>
                    <input class="form-control" type="text" id="id_descripcion" name="descripcion"
                        placeholder="Ingrese la descripci&oacute;n">


                </div>
                <!-- Botón para registrar -->
                <div class="form-group text-center">
                    <button id="id_registrar" type="button" class="btn btn-primary">Registrar</button>
                </div>
            </form>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
        

            // Cargar los usuarios activos para asignar a la incidencia
            cargarUsuariosActivos();

            function cargarUsuariosActivos() {
                $.ajax({
                    type: "GET",
                    url: "/api/solicitudes/activas",  // Endpoint para obtener usuarios activos
                    success: function (data) {
                        var $usuariosSelect = $("select[name='idUsuarios[]']");
                        $usuariosSelect.each(function () {
                            var $select = $(this);
                            $select.empty();
                            $select.append("<option value=''>Seleccione un Usuario</option>");

                            // Agregar las opciones de usuarios al campo de selección
                            $.each(data, function (index, usuario) {
                                $select.append("<option value='" + usuario.idUsuario + "'>" + usuario.nombreCompleto + "</option>");
                            });

                            // Restaurar el valor seleccionado si existe
                            var selectedValue = $select.data('selected-value');
                            if (selectedValue) {
                                $select.val(selectedValue);
                            }
                        });
                    },
                    error: function () {
                        console.error("Error al cargar los usuarios activos.");
                    }
                });
            }

            // Agregar más campos de usuario involucrado
            $(document).on('click', '.btn-add-user', function () {
                var $newUserSelect = $('<div class="form-group usuario-involucrado-group"><select class="form-control" name="idUsuarios[]" required><option value="">Seleccione un Usuario</option></select><span class="btn-add-user btn btn-success">+</span><span class="btn-remove-user btn btn-danger">-</span></div>');
                $('#usuariosInvolucradosContainer').append($newUserSelect);

                // Cargar los usuarios activos en el nuevo campo sin afectar a los anteriores
                cargarUsuariosActivos();
            });

            // Eliminar un campo de usuario involucrado
            $(document).on('click', '.btn-remove-user', function () {
                $(this).closest('.usuario-involucrado-group').remove();
            });

            // Manejo del cambio en el campo de usuario
            $(document).on('change', "select[name='idUsuarios[]']", function () {
                $(this).data('selected-value', $(this).val());
            });

            // Manejo del envío del formulario
            $("#id_registrar").click(function () {
                // Serializar los datos del formulario
                var formData = $('#id_form').serialize() + "&idUsuarios=" + $("select[name='idUsuarios[]']").map(function () {
                    return $(this).val();  // Obtener los valores de los select
                }).get().join(',');

                // Mostrar el loader mientras se espera la respuesta
                Swal.fire({
                    title: 'Procesando...',
                    text: 'Por favor espere...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                // Realizar la petición AJAX
                $.ajax({
                    type: "POST",
                    url: "crearIncidenciaYAsignarUsuarios",  // Endpoint para crear incidencia
                    data: formData,  // Enviar los datos serializados
                    success: function (data) {
                        // Ocultar el loader de SweetAlert
                        Swal.close();

                        // Mostrar el mensaje de éxito
                        if (data && data.MENSAJE) {
                            Swal.fire({
                                title: String.fromCharCode(201) + 'xito',
                                text: data.MENSAJE,
                                icon: 'success'
                            });
                        } else if (data && data.ERROR) {
                            // Mostrar el mensaje de error
                            Swal.fire({
                                title: 'Error',
                                text: data.ERROR,  // Muestra el mensaje de error enviado por el controlador
                                icon: 'error'
                            });
                        } else {
                            // Si no hay MENSAJE ni ERROR, muestra un error genérico
                            Swal.fire({
                                title: 'Error',
                                text: 'Ocurri' + String.fromCharCode(243) + ' un error inesperado.',
                                icon: 'error'
                            });
                        }
                    },
                    error: function () {
                        // Ocultar el loader y mostrar un mensaje de error
                        Swal.close();
                        Swal.fire({
                            title: 'Error',
                            text: 'Ocurri' + String.fromCharCode(243) + ' un error al procesar la solicitud.',
                            icon: 'error'
                        });
                    }
                });
            });


        });
    </script>
</body>

</html>