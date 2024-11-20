import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            MisRecetasView()
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
        MainView()
    }
}
