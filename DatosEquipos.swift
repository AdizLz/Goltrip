import Foundation

struct Equipo: Identifiable, Hashable, Codable {
    let id = UUID()
    let nombre: String
    let nombreBandera: String
    let descripcion: String
    let proximoPartido: String
    let ultimoResultado: String
}

let todosLosEquipos: [Equipo] = [
    Equipo(nombre: "Canadá", nombreBandera: "canada",
           descripcion: "Será la primera vez que participen en dos torneos consecutivos.",
           proximoPartido: "vs México",
           ultimoResultado: "Empate 1-1"),
    Equipo(nombre: "México", nombreBandera: "mexico",
           descripcion: "El Tri ha albergado el evento más veces que cualquier otro país.",
           proximoPartido: "vs Estados Unidos",
           ultimoResultado: "Victoria 2-0"),
    Equipo(nombre: "Estados Unidos", nombreBandera: "estadosunidos",
           descripcion: "Su recorrido hasta semifinales en 1930 es su mejor actuación hasta la fecha.",
           proximoPartido: "vs Canadá",
           ultimoResultado: "Derrota 0-1"),
    Equipo(nombre: "Japón", nombreBandera: "japon",
           descripcion: "Los Samuráis Azules disputarán su octavo Mundial consecutivo.",
           proximoPartido: "vs República de Corea",
           ultimoResultado: "Victoria 3-0"),
    Equipo(nombre: "Argentina", nombreBandera: "argentina",
           descripcion: "La Albiceleste dominó la competencia y logró su pasaje cuatro jornadas antes del final.",
           proximoPartido: "vs Brasil",
           ultimoResultado: "Empate 0-0"),
    Equipo(nombre: "Brasil", nombreBandera: "brasil",
           descripcion: "El único equipo que nunca ha faltado a una Copa del Mundo.",
           proximoPartido: "vs Argentina",
           ultimoResultado: "Victoria 1-0"),
    Equipo(nombre: "Uruguay", nombreBandera: "uruguay",
           descripcion: "Aseguraron su quinta participación consecutiva en el torneo global.",
           proximoPartido: "vs Colombia",
           ultimoResultado: "Victoria 2-1"),
    Equipo(nombre: "Colombia", nombreBandera: "colombia",
           descripcion: "Garantizaron el boleto a la competencia tras perderse Catar 2022.",
           proximoPartido: "vs Ecuador",
           ultimoResultado: "Empate 2-2"),
    Equipo(nombre: "Ecuador", nombreBandera: "ecuador",
           descripcion: "Es la quinta ocasión que la Tri logra el pase a la fase final.",
           proximoPartido: "vs Paraguay",
           ultimoResultado: "Derrota 1-2"),
    Equipo(nombre: "Paraguay", nombreBandera: "paraguay",
           descripcion: "Terminaron 15 años de espera y los Guaraníes estarán de regreso.",
           proximoPartido: "vs Uruguay",
           ultimoResultado: "Empate 1-1"),
]

// Función pura y testeable que filtra equipos
func filtrarEquipos(equipos: [Equipo], conTexto texto: String) -> [Equipo] {
    if texto.isEmpty {
        return equipos
    } else {
        return equipos.filter { $0.nombre.localizedCaseInsensitiveContains(texto) }
    }
}
