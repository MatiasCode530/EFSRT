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

    <title>Registro de Usuario</title>

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
            <h4>Registro de Usuario</h4>
            <form id="id_form" method="post" action="/usuario/registrar">
                <div class="form-group">
                    <label for="nombres">Nombre de la empresa:</label>
                    <input type="text" id="nombres" name="nombres" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="apellidos">Tipo de Empresa:</label>
                    <select id="apellidos" name="apellidos" class="form-control" required>
                        <option value="">Seleccione una opci&oacute;n</option>
                        <option value="EIRL">EIRL</option>
                        <option value="SRL">SRL</option>
                        <option value="SAA">SAA</option>
                        <option value="SA">SA</option>
                        <option value="SAC">SAC</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="dni">RUC:</label>
                    <input type="text" id="dni" name="dni" class="form-control" required maxlength="10">
                </div>

                <div class="form-group">
                    <label for="login">Usuario:</label>
                    <input type="text" id="login" name="login" class="form-control" required readonly>
                </div>
                <div class="form-group">
                    <label for="correo">Correo:</label>
                    <input type="email" id="correo" name="correo" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="direccion">Direcci&oacute;n:</label>
                    <input type="text" id="direccion" name="direccion" class="form-control" required>
                </div>
                <div class="form-group" style="display: none;">
                    <label for="discapacitado">¿Discapacitado?:</label>
                    <input type="text" id="discapacitado" name="discapacitado" class="form-control" value="0">
                </div>
                <div class="form-group">
                    <button type="button" id="id_registrar" class="btn btn-primary">Registrar</button>
                </div>
            </form>

        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {

            // Función para generar el login a partir del nombre y apellidos
            function generarLogin() {
                var nombre = $('#nombres').val(); // Tomar el valor del campo nombre
                var apellidos = $('#apellidos').val(); // Tomar el valor del campo apellidos

                // Convertir a minúsculas y combinar nombre y apellidos para crear el login
                var login = (nombre + '.' + apellidos).slice(0, 40); // Limitar a 10 caracteres

                // Asignar el valor generado al campo login
                $('#login').val(login);
            }

            // Llamar a la función cada vez que el nombre o apellidos cambien
            $('#nombres').on('input', generarLogin);
            $('#apellidos').on('input', generarLogin);

            // Inicializar el valor del login cuando el documento se carga
            generarLogin();

            $("#id_registrar").click(function () {
                var validator = $('#id_form').data('bootstrapValidator');
                validator.validate();

                if (validator.isValid()) {
                    $("#id_registrar").prop('disabled', true); // Deshabilitar el botón mientras procesas
                    Swal.fire({
                        title: 'Procesando...',
                        text: 'Por favor espere...',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading(); // Mostrar carga
                        }
                    });

                    $.ajax({
                        type: "POST",
                        url: "/usuario/registrar",  // Ruta para registrar al usuario
                        data: $('#id_form').serialize(),
                        success: function (data) {
                            Swal.close();

                            // Manejo de la respuesta
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
                        error: function (xhr, status, error) {
                            Swal.close();
                            Swal.fire({
                                title: 'Error',
                                text: 'Ocurri' + String.fromCharCode(243) + '  un error al procesar la solicitud.',
                                icon: 'error'
                            });
                        },
                        complete: function () {
                            $("#id_registrar").prop('disabled', false); // Habilitar el botón nuevamente
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
            function limpiarFormularios() {
                $('#nombres').val('');
                $('#apellidos').val('');
                $('#dni').val('');
                $('#login').val('');
                $('#correo').val('');
                $('#direccion').val('');
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
                    nombres: {
                        validators: {
                            notEmpty: {
                                message: 'El nombre de la empresa es obligatorio'
                            }
                        }
                    },
                    apellidos: {
                        validators: {
                            notEmpty: {
                                message: 'El tipo de empresa es obligatorios'
                            }
                        }
                    },
                    dni: {
                        validators: {
                            notEmpty: {
                                message: 'El RUC es obligatorio'
                            },
                            stringLength: {
                                min: 10,
                                message: 'El RUC debe tener al menos 10 dígitos'
                            }
                        }
                    },
                    correo: {
                        validators: {
                            notEmpty: {
                                message: 'El correo es obligatorio'
                            },
                            emailAddress: {
                                message: 'El correo no es válido'
                            }
                        }
                    },
                    direccion: {
                        validators: {
                            notEmpty: {
                                message: 'La dirección de la empresa es obligatoria'
                            }
                        }
                    },
                }
            });
        });
    </script>



</body>

</html>