import SwiftUI

struct MisRecetasView: View {
    var body: some View {
        VStack {
            EncabezadoView(nickname: "Dani Marinadez", nombre: "Kevin Daniel Rodríguez Martínez")
            
            Text("Mis Recetas")
                .font(.title)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 16) {
                    RecetaCardView(titulo: "Empanadas", autor: "Empanadas Argentinas", rating: 4.9)
                    RecetaCardView(titulo: "Asado Argentino", autor: "Asado de rechupete", rating: 4.8)
                    RecetaCardView(titulo: "Pinchos de carne", autor: "Para pinchar el hambre", rating: 3.8)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                // Acción para agregar recetas
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding()
        }
        .background(Color(.systemGreen).opacity(0.1))
        .ignoresSafeArea(edges: .top)
    }
}

struct MisRecetasView_Previews: PreviewProvider {
    static var previews: some View {
        MisRecetasView()
    }
}
