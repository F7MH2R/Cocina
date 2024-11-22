import SwiftUI

struct TabBar: View {
    let datos:DatosJson
    var body: some View {
        TabView {
            
                RecetasView(datosUsuario: datos)
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Inicio")
                        }
                    }.background(Color.pink)
                    .foregroundColor(.white)
                
                ListaIngredientesView(userId: datos.id_usuario)
                    .tabItem {
                        VStack {
                            Image(systemName: "list.bullet")
                            Text("Lista")
                        }
                    }
                MainView(datos: datos)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Perfil")
                        }
                    }.background(Color.pink)
                    .foregroundColor(.white)
            }.background(Color.pink)
                .foregroundColor(.white)
        
        
            
        
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(datos: DatosJson(
            id_usuario: 1,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
            .previewLayout(.sizeThatFits)
    }
}
