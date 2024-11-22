import SwiftUI

struct MainView: View {
    let datos: DatosJson
    var body: some View {
        TabView {
            MisRecetasView(datos: datos)
                .tabItem {
                    VStack {
                        Image(systemName: "star.circle.fill")
                        Text("Mis Recetas")
                    }
                }
            
            ListaView()
                .tabItem {
                    VStack {
                        Image(systemName: "bookmark.fill")
                        Text("Favoritos")
                    }
                }
            
            PerfilView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Mi Perfil")
                    }
                }
        }
        .accentColor(.pink)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(datos: DatosJson(
            id_usuario: 1,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
