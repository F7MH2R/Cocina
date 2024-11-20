import SwiftUI

struct ListaView: View {
    @State private var recetas: [Receta] = [] // Lista de recetas favoritas
    @State private var searchText: String = "" // Campo para buscar por nombre o creador
    @State private var tags: String = "" // Campo para buscar por tags
    @State private var errorMessage: String? // Mensaje de error en caso de problemas con la API

    var body: some View {
        VStack {
            // Encabezado
            EncabezadoView(nickname: "Dani Marinadez", nombre: "Kevin Daniel Rodríguez Martínez")
            
            // Título
            Text("Favoritos")
                .font(.title)
                .padding(.top)
            
            // Campos de búsqueda
            VStack(spacing: 10) {
                TextField("Buscar por nombre o creador", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Buscar por tags (separados por comas)", text: $tags)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    obtenerRecetasFavoritas(userId: 3, nombre: searchText, tags: tags) // Cambia `3` al ID del usuario autenticado
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
            
            // Listado de recetas favoritas
            ScrollView {
                if recetas.isEmpty {
                    Text("No se encontraron recetas favoritas.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        ForEach(recetas) { receta in
                            VStack(alignment: .leading, spacing: 8) {
                                // Imagen de la receta
                                if let imagenUrl = receta.Imagenes.first?.url_imagen {
                                    AsyncImage(url: URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/obtenerimg/\(imagenUrl)")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 150)
                                            .clipped()
                                    } placeholder: {
                                        Color.gray
                                            .frame(height: 150)
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
                                    Text(receta.descripcion)
                                        .font(.headline)
                                    Text("Por \(receta.Usuarios.nombre)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("Promedio: \(receta.promedioResenas, specifier: "%.1f") (\(receta.cantidadResenas) reseñas)")
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
            obtenerRecetasFavoritas(userId: 3) // Llamada inicial para cargar las recetas favoritas
        }
    }
    
    // Función para consumir la API y obtener recetas favoritas
    func obtenerRecetasFavoritas(userId: Int, nombre: String = "", tags: String = "") {
        // Construir la URL con los parámetros
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/recetafav/\(userId)?nombre=\(nombre)&tags=\(tags)") else {
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
                    let recetasFavoritas = try JSONDecoder().decode([Receta].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.recetas = recetasFavoritas
                        self.errorMessage = nil // Limpiar errores
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error al procesar los datos"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al obtener las recetas favoritas"
                }
            }
        }.resume()
    }
}

// Vista previa
struct ListaView_Previews: PreviewProvider {
    static var previews: some View {
        ListaView()
    }
}
