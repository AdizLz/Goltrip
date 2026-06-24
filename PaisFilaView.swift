import SwiftUI

struct PaisFilaView: View {
    let equipo: Equipo

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 15) {
                Image(equipo.nombreBandera)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 25)

                Text(equipo.nombre)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Text(equipo.descripcion)
                .font(.body)
                .foregroundColor(.white)
                .padding(.bottom, 5)

            HStack {
                Image(systemName: Constants.SFSymbols.calendario)
                    .foregroundColor(.white)
                Text("\(Constants.Textos.proximoPartido) \(equipo.proximoPartido)")
                    .foregroundColor(.white)
            }
            .font(.subheadline)

            HStack {
                Image(systemName: Constants.SFSymbols.grafico)
                    .foregroundColor(.white)
                Text("\(Constants.Textos.ultimoResultado) \(equipo.ultimoResultado)")
                    .foregroundColor(.white)
            }
            .font(.subheadline)
        }
        .padding(.vertical, 10)
    }
}
