document.addEventListener("DOMContentLoaded", function() {

    // 1. MENÚ DESPLEGABLE (HOVER)
    var itemsMenu = document.querySelectorAll("header nav > ul > li");
    for (var i = 0; i < itemsMenu.length; i++) {
        itemsMenu[i].onmouseenter = function() {
            var sub = this.querySelector("ul");
            if (sub) sub.style.display = "block";
        };
        itemsMenu[i].onmouseleave = function() {
            var sub = this.querySelector("ul");
            if (sub) sub.style.display = "none";
        };
    }

    // 2. CONTADOR REGRESIVO (6 de diciembre de 2026)
    var fechaFin = new Date("December 6, 2026 14:00:00").getTime();
    setInterval(function() {
        var ahora = new Date().getTime();
        var diff = fechaFin - ahora;
        if (diff > 0) {
            var d = Math.floor(diff / (1000 * 60 * 60 * 24));
            var h = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            var s = Math.floor((diff % (1000 * 60)) / 1000);
            var reloj = document.getElementById("reloj-contador");
            if (reloj) reloj.textContent = d + " días, " + h + "h : " + m + "m : " + s + "s";
        }
    }, 1000);

    // 3. CÁLCULO DE PRECIOS EN ENTRADAS
    var btnCalc = document.getElementById("calcularPrecio");
    if (btnCalc) {
        btnCalc.onclick = function() {
            var tipo = document.getElementById("tipoEntrada").value;
            var zona = document.getElementById("zonaEntrada").value;
            var total = (tipo === "infantil") ? 30 : ((zona === "zona1") ? 80 : 60);
            document.getElementById("precio").value = total + " €";
        };
    }

    // 4. CONDICIONES DE COMPRA (ACTIVAR / DESACTIVAR BOTÓN)
    var check = document.getElementById("aceptaCondiciones");
    var btnComprar = document.getElementById("btnComprar");
    if (check && btnComprar) {
        btnComprar.disabled = true;
        check.onchange = function() {
            btnComprar.disabled = !check.checked;
        };
    }

    // 5. VALIDACIÓN FORMULARIO ENTRADAS
    var formEntrada = document.getElementById("formEntrada");
    if (formEntrada) {
        formEntrada.onsubmit = function(e) {
            var dni = document.getElementById("dni").value;
            var email = document.getElementById("email").value;
            var edad = parseInt(document.getElementById("edad").value);
            var tipo = document.getElementById("tipoEntrada").value;
            var ok = true;

            document.getElementById("errorDni").textContent = /^\d{8}[A-Z]$/.test(dni) ? "" : "DNI incorrecto.";
            document.getElementById("errorEmail").textContent = email.includes("@") ? "" : "Email no válido.";
            document.getElementById("errorEdad").textContent = ((tipo === "infantil" && edad < 18) || (tipo === "adulto" && edad >= 18)) ? "" : "Edad no acorde al tipo de entrada.";

            if (!(/^\d{8}[A-Z]$/.test(dni)) || !email.includes("@") || (tipo === "infantil" && edad >= 18) || (tipo === "adulto" && edad < 18)) {
                ok = false;
            }

            if (!ok) {
                e.preventDefault();
            } else {
                alert("Datos válidos para la demostración. No se ha enviado ninguna compra.");
            }
        };
    }

    // El sitio estático no envía formularios ni autentica usuarios.
    document.querySelectorAll("form").forEach(function(formulario) {
        formulario.addEventListener("submit", function(evento) {
            evento.preventDefault();
        });
    });

    // 7. SORTEO DE PILOTOS
    var btnSorteo = document.getElementById("btnComprobarSorteo");
    if (btnSorteo) {
        btnSorteo.onclick = function() {
            var p1 = document.getElementById("piloto1").value;
            var p2 = document.getElementById("piloto2").value;
            var p3 = document.getElementById("piloto3").value;

            if (!p1 || !p2 || !p3) {
                alert("Selecciona los tres pilotos.");
                return;
            }

            var drivers = ["Verstappen", "Hamilton", "Leclerc", "Alonso", "Sainz"];
            var win = [];
            while(win.length < 3) {
                var pick = drivers[Math.floor(Math.random() * drivers.length)];
                if(!win.includes(pick)) win.push(pick);
            }

            var aciertos = (p1 === win[0] ? 1 : 0) + (p2 === win[1] ? 1 : 0) + (p3 === win[2] ? 1 : 0);
            var mensaje = "Podio: 1º " + win[0] + ", 2º " + win[1] + ", 3º " + win[2] + ".\nAciertos: " + aciertos + " (Premio: " + (aciertos * 1000) + "€)";
            document.getElementById("resultadoSorteoContainer").innerText = mensaje;
        };
    }

    // 8. CARRUSEL DINÁMICO
    var galeria = [
        { src: "img/f1_bilbao1.jpg", text: "Monoplaza cruzando el puente Bizkaia" },
        { src: "img/f1_bilbao2.jpg", text: "Salida oficial frente al Museo Guggenheim" },
        { src: "img/f1_bilbao3.jpg", text: "Ambiente en la Fan Zone de Bilbao" },
        { src: "img/f1_bilbao4.jpg", text: "Monoplaza en pruebas nocturnas" },
        { src: "img/f1_bilbao5.jpg", text: "Exhibición de boxes (Pit Stop)" }
    ];
    var imgBox = document.getElementById("carrusel-img");
    var textBox = document.getElementById("carrusel-titulo");

    if (imgBox && textBox) {
        var index = 0;
        setInterval(function() {
            index = (index + 1) % galeria.length;
            imgBox.src = galeria[index].src;
            textBox.textContent = galeria[index].text;
        }, 3000);
    }

});
