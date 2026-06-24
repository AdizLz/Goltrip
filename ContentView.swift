import SwiftUI

struct ContentView: View {
    @AppStorage("haCompletadoSeleccion") private var haCompletadoSeleccion: Bool = false
    
    // Guardaremos un array de Strings (los nombres de los equipos) en formato Data.
    @AppStorage("nombresEquiposSeleccionados") private var nombresGuardadosData: Data = Data()
    
    // Esta propiedad ahora reconstruye la lista de equipos a partir de los nombres guardados
    private var equiposGuardados: [Equipo] {
        // 1. Decodificamos los datos para obtener los nombres [String]
        guard let nombresGuardados = try? JSONDecoder().decode([String].self, from: nombresGuardadosData) else {
            return []
        }
        
        // 2. Usamos los nombres para filtrar la lista maestra y encontrar los equipos completos
        return todosLosEquipos.filter { equipo in
            nombresGuardados.contains(equipo.nombre)
        }
    }

    var body: some View {
        /*if !haCompletadoSeleccion {
            SeleccionEquiposView { equiposQueElUsuarioEligio in
                // 1. Convertimos los equipos seleccionados en una lista de solo nombres
                let nombresParaGuardar = equiposQueElUsuarioEligio.map { $0.nombre }
                
                // 2. Codificamos esa lista de nombres a Data y la guardamos
                if let data = try? JSONEncoder().encode(nombresParaGuardar) {
                    nombresGuardadosData = data
                }
                
                // 3. Marcamos la selección como completada
                haCompletadoSeleccion = true
            }
        } else {
            // Pasamos la lista de equipos reconstruida a la vista principal
            MainView(equiposSeleccionados: equiposGuardados)
        }*/
    }
}
