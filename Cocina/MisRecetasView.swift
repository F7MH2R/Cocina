import SwiftUI

struct MisRecetasView: View {
    @State private var recetas: [RecetaUsuarioDetalle] = [] // Usando el modelo RecetaUsuarioDetalle
    @State private var searchText: String = "" // Campo para buscar por nombre o creador
    @State private var tags: String = "" // Campo para buscar por tags
    @State private var errorMessage: String? // Mensaje de error en caso de problemas con la API
    @State private var showToast = false
    @State private var toastMessage = "" // Mensaje del toast
    let datos: DatosJson

    var body: some View {
        NavigationView {
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
                                VStack {
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
                                    }
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                    
                                    // Botones de acción
                                    HStack(spacing: 10) {
                                        // Botón de Detalle
                                        NavigationLink(destination: RecetaDetalleView(recetaId: receta.id, datos: datos)) {
                                            HStack {
                                                Image(systemName: "eye")
                                                Text("Detalle")
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        }
                                        
                                        // Botón de Editar
                                        NavigationLink(destination: EditarRecetaView(recetaId: receta.id, datos: datos)) {
                                            HStack {
                                                Image(systemName: "pencil")
                                                Text("Editar")
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        }
                                    }
                                    
                                    // Botón para eliminar receta
                                    Button(action: {
                                        eliminarReceta(recetaId: receta.id)
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Eliminar")
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
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
                
                // Toast para confirmar acciones
                if showToast {
                    VStack {
                        Spacer()
                        Text(toastMessage)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.showToast = false
                                }
                            }
                    }
                }
            }
            .background(Color(.systemGreen).opacity(0.1))
            .ignoresSafeArea(edges: .top)
            .onAppear {
                fetchRecetasUsuario(userId: datos.id_usuario) // Cargar recetas creadas por el usuario
            }
        }}
    
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
    
    // Función para eliminar una receta
    func eliminarReceta(recetaId: Int) {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/deletereceta/\(recetaId)") else {
            self.errorMessage = "URL inválida"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al conectar con el servidor: \(error.localizedDescription)"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.recetas.removeAll { $0.id == recetaId }
                    self.toastMessage = "Receta eliminada con éxito"
                    self.showToast = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al eliminar la receta"
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
