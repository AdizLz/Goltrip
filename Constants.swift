import Foundation
import SwiftUI

// Un enum sin casos es una excelente manera de agrupar constantes
// para que no puedan ser instanciadas.
enum Constants {
    
    enum Titulos {
        static let homeSinSeleccion = "Home"
        static let seleccionEquipos = "Elige los equipos que quieres seguir"
    }

    enum Textos {
        static let seleccionEquiposSubtitulo = "Consigue un acceso más rápido a las noticias, a los próximos partidos y mucho más."
        static let noEquiposTitulo = "No has seleccionado equipos"
        static let noEquiposSubtitulo = "Ve a tu Perfil para elegir tus equipos favoritos."
        static let proximoPartido = "Próximo partido:"
        static let ultimoResultado = "Último resultado:"
    }

    enum SFSymbols {
        static let noEquipos = "shield.slash.fill"
        static let calendario = "calendar"
        static let grafico = "chart.bar.fill"
    }
    
    // También puedes centralizar colores aquí
    enum Colores {
        static let fondoPrincipal = Color(red: 25/255, green: 38/255, blue: 62/255)
        static let fondoItem = Color(red: 43/255, green: 56/255, blue: 82/255)
    }
}
