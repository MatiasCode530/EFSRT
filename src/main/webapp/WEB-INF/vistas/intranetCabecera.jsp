<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tu T&iacutetulo</title>
    <style>
        .navbar-custom {
            width: 100%;
            margin: 0% auto;
            padding: 30px;
            background-color: #05407a;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            color: white;
        }

        .navbar-custom .navbar-header {
            width: 80%;
        }

        .navbar-custom .navbar-collapse {
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="navbar navbar-inverse navbar-fixed-top navbar-custom">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>

                <div class="collapse navbar-collapse">
                    <ul class="nav navbar-nav navbar-left">
                        <li><a href="verIntranetHome">Home</a></li>
                    </ul>

                    <ul class="nav navbar-nav">
                        <!-- Opciones de Registros para el tipo 1 Profesor -->
                        <c:if test="${!empty sessionScope.objMenusTipo1}">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Profesor <b class="caret"></b>
                                </a>
                                <ul class="dropdown-menu">
                                    <c:forEach var="x" items="${sessionScope.objMenusTipo1}">
                                        <li>
                                            <a href="${x.ruta}">${x.nombre}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:if>

                        <!-- Opciones para Alumno) -->
                        <c:if test="${!empty sessionScope.objMenusTipo2}">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Alumno <b class="caret"></b>
                                </a>
                                <ul class="dropdown-menu">
                                    <c:forEach var="x" items="${sessionScope.objMenusTipo2}">
                                        <li>
                                            <a href="${x.ruta}">${x.nombre}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:if>

                        <!-- Opciones para seguridad -->
                        <c:if test="${!empty sessionScope.objMenusTipo3}">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Seguridad <b class="caret"></b>
                                </a>
                                <ul class="dropdown-menu">
                                    <c:forEach var="x" items="${sessionScope.objMenusTipo3}">
                                        <li>
                                            <a href="${x.ruta}">${x.nombre}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:if>

                        <!-- Opciones para proveedor -->
                        <c:if test="${!empty sessionScope.objMenusTipo4}">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Proveedores <b class="caret"></b>
                                </a>
                                <ul class="dropdown-menu">
                                    <c:forEach var="x" items="${sessionScope.objMenusTipo4}">
                                        <li>
                                            <a href="${x.ruta}">${x.nombre}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:if>

                          <!-- Opciones para Supervisor -->
                          <c:if test="${!empty sessionScope.objMenusTipo5}">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Supervisor <b class="caret"></b>
                                </a>
                                <ul class="dropdown-menu">
                                    <c:forEach var="x" items="${sessionScope.objMenusTipo5}">
                                        <li>
                                            <a href="${x.ruta}">${x.nombre}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:if>


                    </ul>

                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="logout">Salir</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
