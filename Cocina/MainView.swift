import SwiftUI

struct MainView: View {
    let datos: DatosJson
    var body: some View {
        TabView {
            MisRecetasView(datos: datos)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Inicio")
                    }
                }
            
            ListaView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Lista")
                    }
                }
            
            PerfilView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Perfil")
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
