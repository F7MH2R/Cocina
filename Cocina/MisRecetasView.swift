import SwiftUI

struct MisRecetasView: View {
    @State private var recetas: [RecetaUsuarioDetalle] = [] // Usando el modelo RecetaUsuarioDetalle
    @State private var searchText: String = "" // Campo para buscar por nombre o creador
    @State private var tags: String = "" // Campo para buscar por tags
    @State private var errorMessage: String? // Mensaje de error en caso de problemas con la API
    let datos: DatosJson

    var body: some View {
        VStack {
            // Encabezado
            EncabezadoView(nickname: "Dani Marinadez", nombre: "Kevin Daniel Rodríguez Martínez")
            
            Text("Mis Recetas")
                .font(.title)
                .padding(.top)
            
            // Campos de búsqueda
            VStack(spacing: 10) {
                TextField("Buscar por nombre o creador", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    fetchRecetasUsuario(userId: datos.id_usuario, nombre: searchText, tags: tags)
                }) {
                    Text("Buscar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            // Lista de recetas creadas por el usuario
            ScrollView {
                if recetas.isEmpty {
                    Text("No se encontraron recetas.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        ForEach(recetas) { receta in
                            NavigationLink(destination: RecetaDetalleView(recetaId: receta.id, datos: datos)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    // Imagen de la receta
                                    if let imagenUrl = receta.imagenesDeLaReceta.first?.enlaceDeLaImagen {
                                        AsyncImage(url: URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/obtenerimg/\(imagenUrl)")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 150)
                                                .clipped()
                                        } placeholder: {
                                            Color.gray
                                                .frame(height: 150)
                                                .overlay(
                                                    Text("Sin imagen")
                                                        .foregroundColor(.white)
                                                        .font(.caption)
                                                )
                                        }
                                    } else {
                                        Color.gray
                                            .frame(height: 150)
                                            .overlay(
                                                Text("Sin imagen")
                                                    .foregroundColor(.white)
                                                    .font(.caption)
                                            )
                                    }

                                    // Detalles de la receta
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(receta.descripcionDeLaReceta)
                                            .font(.headline)
                                        Text("Por \(receta.creadorDeLaReceta.nombreDelCreador)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("Promedio: \(receta.promedioCalificaciones, specifier: "%.1f") (\(receta.totalDeResenas) reseñas)")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)
                                    
                                    Divider()
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // Mensaje de error si ocurre algo
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }
        }
        .background(Color(.systemGreen).opacity(0.1))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            fetchRecetasUsuario(userId: datos.id_usuario) // Cargar recetas creadas por el usuario
        }
    }
    
    // Función para consumir la API y obtener las recetas creadas por el usuario
    func fetchRecetasUsuario(userId: Int, nombre: String = "", tags: String = "") {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/recetauser/\(userId)?nombre=\(nombre)") else {
            self.errorMessage = "URL inválida"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al conectar con el servidor"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    // Decodificar la respuesta JSON
                    let recetasCreadas = try JSONDecoder().decode([RecetaUsuarioDetalle].self, from: data)
                    DispatchQueue.main.async {
                        self.recetas = recetasCreadas
                        self.errorMessage = nil // Limpiar errores
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error al procesar los datos"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al obtener las recetas creadas"
                }
            }
        }.resume()
    }
}

struct MisRecetasView_Previews: PreviewProvider {
    static var previews: some View {
        MisRecetasView(datos: DatosJson(
            id_usuario: 1,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
