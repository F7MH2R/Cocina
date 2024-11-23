import SwiftUI

// Modelo principal del detalle de la receta
struct RecetaDetalle: Decodable {
    let id_receta: Int
    let id_usuario: Int
    let descripcion: String
    let porciones: Int
    let tiempo: Int
    let video: String
    let fecha: String
    let Ingredientes: [Ingrediente]
    let Usuarios: Usuario
    let Pasos: [Paso]
    let Imagenes: [Imagen]
    let TiposRecetas: [TipoReceta]
    let Comentarios: [Comentario]
    let _count: ReportCount
    let isFavorito: Bool
    let userResena: Int
    let vistas: Int
    let denunciado: Bool

    struct Ingrediente: Decodable {
        let id_ingrediente: Int
        let id_receta: Int
        let ingrediente: String
    }

    struct Usuario: Decodable {
        let nombre: String
    }

    struct Paso: Decodable {
        let id_paso: Int
        let id_receta: Int
        let paso: String
        let orden: Int
    }

    struct Imagen: Decodable {
        let url_imagen: String
    }

    struct TipoReceta: Decodable {
        let id_receta: Int
        let id_tipo: Int
        let Tipos: Tipo

        struct Tipo: Decodable {
            let id_tipo: Int
            let nombre: String
        }
    }

    struct Comentario: Decodable {
        // Ajusta los campos según los datos futuros de "Comentarios"
    }

    struct ReportCount: Decodable {
        let Reportes: Int
    }
}

struct RecetaDetalleView: View {
    let recetaId: Int
    let datos: DatosJson
        @State private var recetaDetalle: RecetaDetalle?
        @State private var isLoading = true
        @State private var errorMessage: String?
        @State private var isFavorito = false // Estado para el botón de favoritos
        @State private var resenaValor: Int = 0 // Estado para la calificación
        @State private var showToast = false // Estado para mostrar el toast
        @State private var toastMessage = "" // Mensaje del toast

        var body: some View {
            ZStack {
                Color(red: 224/255, green: 255/255, blue: 224/255)
                    .edgesIgnoringSafeArea(.all)

                if isLoading {
                    ProgressView("Cargando detalles...")
                } else if let errorMessage = errorMessage {
                    ErrorView(message: errorMessage)
                } else if let detalle = recetaDetalle {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            RecetaImageView(imagenes: detalle.Imagenes)
                            RecetaHeaderView(detalle: detalle)

                            // Botones de acción
                            HStack {
                                Button(action: {
                                    anadirAFavoritos()
                                }) {
                                    HStack {
                                        Image(systemName: "bookmark.fill")
                                        Text(isFavorito ? "Favorito" : "Guardar")
                                    }
                                    .padding()
                                    .background(isFavorito ? Color.yellow : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }

                                Button(action: {
                                    anadirAListaDeCompras()
                                }) {
                                    HStack {
                                        Image(systemName: "cart.fill")
                                        Text("Añadir a lista")
                                    }
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                            }

                            // Reseñas de calificación
                            VStack(alignment: .leading) {
                                Text("Calificación")
                                    .font(.headline)
                                    .padding(.top)

                                HStack {
                                    ForEach(1...5, id: \.self) { star in
                                        Image(systemName: star <= resenaValor ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .onTapGesture {
                                                enviarResena(valor: star)
                                            }
                                    }
                                }
                            }

                            IngredientesView(ingredientes: detalle.Ingredientes)
                            PasosView(pasos: detalle.Pasos)
                           
                        }
                        .padding()
                    }
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
            .onAppear {
                fetchRecetaDetalle()
            }
            .navigationTitle("Detalle de Receta")
        }
    // Función para añadir a favoritos
        func anadirAFavoritos() {
            guard let url = URL(string: "\(Constants.API.baseURL)/addfav") else {
                errorMessage = "URL inválida"
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["idUsuario": datos.id_usuario, "idReceta": recetaId]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil, let response = response as? HTTPURLResponse, response.statusCode != 500 {
                    DispatchQueue.main.async {
                        isFavorito.toggle()
                        toastMessage = isFavorito ? "Añadido a favoritos" : "Eliminado de favoritos"
                        showToast = true
                    }
                }
            }.resume()
        }

        // Función para añadir a la lista de compras
        func anadirAListaDeCompras() {
            guard let url = URL(string: "\(Constants.API.baseURL)/anadirlista") else {
                errorMessage = "URL inválida"
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["id_usuario": datos.id_usuario, "id_receta": recetaId]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    DispatchQueue.main.async {
                        toastMessage = "Añadido a lista de compras"
                        showToast = true
                    }
                }
            }.resume()
        }

        // Función para enviar reseñas
        func enviarResena(valor: Int) {
            guard let url = URL(string: "\(Constants.API.baseURL)/resena") else {
                errorMessage = "URL inválida"
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["id_usuario": datos.id_usuario, "id_receta": recetaId, "valor": valor]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    DispatchQueue.main.async {
                        resenaValor = valor
                        toastMessage = "Reseña enviada: \(valor) estrella(s)"
                        showToast = true
                    }
                }
            }.resume()
        }
    func fetchRecetaDetalle() {
        guard let url = URL(string: "\(Constants.API.baseURL)/recetadetalle/\(datos.id_usuario)/\(recetaId)") else {
            errorMessage = "URL inválida"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Error: \(error.localizedDescription)"
                    isLoading = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "Datos vacíos desde la API"
                    isLoading = false
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(RecetaDetalle.self, from: data)
                DispatchQueue.main.async {
                    recetaDetalle = decodedData
                    isLoading = false
                    isFavorito = recetaDetalle?.isFavorito ?? false
                    resenaValor = recetaDetalle?.userResena ?? 0
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Error al decodificar datos: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }.resume()
    }
}

// Subvistas para organizar el diseño

struct RecetaImageView: View {
    let imagenes: [RecetaDetalle.Imagen]

    var body: some View {
        if let primeraImagen = imagenes.first?.url_imagen,
           let imageUrl = URL(string: "\(Constants.API.baseURL)/obtenerimg/\(primeraImagen)") {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .foregroundColor(.gray)
        }
    }
}

struct RecetaHeaderView: View {
    let detalle: RecetaDetalle

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(detalle.descripcion)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)

            Text("Por \(detalle.Usuarios.nombre)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("\(detalle.porciones) porciones | \(detalle.tiempo) minutos")
                .font(.subheadline)

            Text("Vistas: \(detalle.vistas)")
                .font(.subheadline)

        }
    }
}

struct IngredientesView: View {
    let ingredientes: [RecetaDetalle.Ingrediente]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredientes")
                .font(.headline)
                .padding(.top)

            ForEach(ingredientes, id: \.id_ingrediente) { ingrediente in
                Text("- \(ingrediente.ingrediente)")
                    .font(.body)
            }
        }
    }
}

struct PasosView: View {
    let pasos: [RecetaDetalle.Paso]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Instrucciones")
                .font(.headline)
                .padding(.top)

            ForEach(pasos, id: \.orden) { paso in
                Text("\(paso.orden). \(paso.paso)")
                    .font(.body)
            }
        }
    }
}

struct CategoriasView: View {
    let categorias: [RecetaDetalle.TipoReceta]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Categorías")
                .font(.headline)
                .padding(.top)

            ForEach(categorias, id: \.id_tipo) { tipoReceta in
                Text("- \(tipoReceta.Tipos.nombre)")
                    .font(.body)
            }
        }
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct RecetaDetalleView_Previews: PreviewProvider {
    static var previews: some View {
        RecetaDetalleView(recetaId: 1, datos: DatosJson(
            id_usuario: 1,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
