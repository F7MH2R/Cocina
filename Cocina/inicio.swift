import SwiftUI

struct RecetasView: View {
    let datosUsuario: DatosJson // Modelo para recibir los datos del usuario

    @State private var recetas: [Receta] = []
    @State private var isLoading: Bool = true
    @State private var todo: String = " "

    var body: some View {
        NavigationView { // Agregar NavigationView para habilitar la navegación
            ZStack {
                // Fondo verde claro
                Color(red: 224/255, green: 255/255, blue: 224/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Encabezado con botón flotante
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Bienvenido")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(datosUsuario.nombre) // Mostrar el nombre del usuario dinámicamente
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text(todo)
                        Button(action: {
                            print("Agregar receta")
                        }) {
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.pink)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    
                    // Lista de recetas
                    if isLoading {
                        ProgressView("Cargando recetas...")
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(recetas) { receta in
                                    RecetaCard(receta: receta, datos: datosUsuario)
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Barra de navegación inferior
                    HStack {
                        TabButton(icon: "house.fill", label: "Inicio")
                        Spacer()
                        TabButton(icon: "list.bullet", label: "Lista")
                        Spacer()
                        TabButton(icon: "person.fill", label: "Perfil")
                    }
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                }
            }
            .onAppear {
                fetchRecetas()
            }
        }
    }

    // Función para consumir la API
    func fetchRecetas() {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/receta") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al obtener recetas: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.todo = "Error al obtener datos"
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta HTTP: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("Datos vacíos desde la API")
                DispatchQueue.main.async {
                    self.todo = "Sin datos disponibles"
                }
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.todo = "Datos cargados correctamente"
                    print("Datos crudos: \(jsonString.prefix(500))...") // Imprime los primeros 500 caracteres
                }
            }

            do {
                let apiResponse = try JSONDecoder().decode([Receta].self, from: data)
                DispatchQueue.main.async {
                    self.recetas = apiResponse
                    self.isLoading = false
                }
            } catch {
                print("Error al decodificar datos: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.todo = "Error al decodificar datos"
                }
            }
        }.resume()
    }
}


struct RecetaCard: View {
    let receta: Receta
    let datos: DatosJson
    var body: some View {
        NavigationLink(destination: RecetaDetalleView(recetaId: receta.id, datos: datos)) { // Enviar el id de la receta
            HStack {
                // Generar la URL del endpoint para cargar la imagen
                if let imageUrl = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/obtenerimg/\(receta.Imagenes.first?.url_imagen ?? "")") {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                } else {
                    // Imagen predeterminada si no hay URL
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading) {
                    Text(receta.descripcion)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("de \(receta.Usuarios.nombre)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(receta.porciones) porciones | \(receta.tiempo) minutos")
                        .font(.caption)
                        .foregroundColor(.gray)

                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", receta.promedioResenas))
                            .font(.caption)
                            .foregroundColor(.black)
                        Text("(\(receta.cantidadResenas) Reseñas)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 10)

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}



// Botón de la barra de navegación
struct TabButton: View {
    let icon: String
    let label: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.headline)
            Text(label)
                .font(.caption)
        }
    }
}

struct RecetasView_Previews: PreviewProvider {
    static var previews: some View {
        RecetasView(datosUsuario: DatosJson(
            id_usuario: 1,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
