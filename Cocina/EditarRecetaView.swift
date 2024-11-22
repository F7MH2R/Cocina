import SwiftUI

struct EditarRecetaView: View {
    let recetaId: Int
    let datos: DatosJson

    @State private var recetaDetalle: RecetaDetalle?
    @State private var nombreReceta: String = ""
    @State private var ingredientes: [String] = []
    @State private var pasos: [String] = []
    @State private var porciones: Int = 0
    @State private var tiempo: Int = 0
    @State private var imagenReceta: UIImage? = nil
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showImagePicker = false
    @State private var showAddIngrediente = false
    @State private var showAddPaso = false
    @State private var nuevoIngrediente: String = ""
    @State private var nuevoPaso: String = ""

    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Cargando...")
                } else if let errorMessage = errorMessage {
                    ErrorView(message: errorMessage)
                } else if let detalle = recetaDetalle {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            // Imagen principal
                            if let primeraImagen = detalle.Imagenes.first?.url_imagen,
                               let imageUrl = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/obtenerimg/\(primeraImagen)") {
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

                            // Subir nueva imagen
                            Button(action: {
                                showImagePicker.toggle()
                            }) {
                                Text("Cambiar Imagen")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(image: $imagenReceta)
                            }

                            // Nombre de la receta
                            TextField("Nombre de la receta", text: $nombreReceta)
                                .font(.title2)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)

                            // Ingredientes
                            VStack(alignment: .leading) {
                                Text("Ingredientes")
                                    .font(.headline)

                                ForEach(ingredientes.indices, id: \.self) { index in
                                    HStack {
                                        Text(ingredientes[index])
                                            .font(.body)
                                        Spacer()
                                        Button(action: {
                                            ingredientes.remove(at: index)
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }

                                Button(action: {
                                    showAddIngrediente.toggle()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.pink)
                                }
                                .sheet(isPresented: $showAddIngrediente) {
                                    VStack {
                                        Text("Agregar Ingrediente")
                                            .font(.headline)
                                        TextField("Ingrediente", text: $nuevoIngrediente)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()
                                        HStack {
                                            Button("Añadir", action: {
                                                if !nuevoIngrediente.isEmpty {
                                                    ingredientes.append(nuevoIngrediente)
                                                    nuevoIngrediente = ""
                                                    showAddIngrediente.toggle()
                                                }
                                            })
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.green)
                                            .cornerRadius(10)

                                            Button("Cancelar", action: {
                                                showAddIngrediente.toggle()
                                            })
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.red)
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .padding()

                            // Pasos
                            VStack(alignment: .leading) {
                                Text("Pasos")
                                    .font(.headline)

                                ForEach(pasos.indices, id: \.self) { index in
                                    HStack {
                                        Text("\(index + 1). \(pasos[index])")
                                            .font(.body)
                                        Spacer()
                                        Button(action: {
                                            pasos.remove(at: index)
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }

                                Button(action: {
                                    showAddPaso.toggle()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.pink)
                                }
                                .sheet(isPresented: $showAddPaso) {
                                    VStack {
                                        Text("Agregar Paso")
                                            .font(.headline)
                                        TextField("Paso", text: $nuevoPaso)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()
                                        HStack {
                                            Button("Añadir", action: {
                                                if !nuevoPaso.isEmpty {
                                                    pasos.append(nuevoPaso)
                                                    nuevoPaso = ""
                                                    showAddPaso.toggle()
                                                }
                                            })
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.green)
                                            .cornerRadius(10)

                                            Button("Cancelar", action: {
                                                showAddPaso.toggle()
                                            })
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.red)
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .padding()

                            // Porciones y tiempo
                            HStack {
                                TextField("Porciones", value: $porciones, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .padding(.vertical)

                                TextField("Tiempo en minutos", value: $tiempo, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .padding(.vertical)
                            }

                            // Botón para guardar cambios
                            Button(action: {
                                guardarReceta()
                            }) {
                                Text("Guardar Cambios")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
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
            .navigationTitle("Editar Receta")
        }
    }

    func fetchRecetaDetalle() {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/recetadetalle/1/\(recetaId)") else {
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
                    nombreReceta = decodedData.descripcion
                    ingredientes = decodedData.Ingredientes.map { $0.ingrediente }
                    pasos = decodedData.Pasos.sorted(by: { $0.orden < $1.orden }).map { $0.paso }
                    porciones = decodedData.porciones
                    tiempo = decodedData.tiempo
                    
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Error al decodificar datos: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }.resume()
    }

    func guardarReceta() {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/updatereceta/\(recetaId)") else {
            errorMessage = "URL inválida"
            return
        }

        let recetaData: [String: Any] = [
            "descripcion": nombreReceta,
            "porciones": porciones,
            "tiempo": tiempo,
            "Ingredientes": ingredientes,
            "Pasos": pasos.enumerated().map { ["paso": $1, "orden": $0 + 1] },
            "id_usuario": datos.id_usuario
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: recetaData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "Error en la respuesta del servidor."
                }
                return
            }

            DispatchQueue.main.async {
                toastMessage = "Receta actualizada con éxito"
                showToast = true
            }
        }.resume()
    }
}

struct EditarRecetaView_Previews: PreviewProvider {
    static var previews: some View {
        EditarRecetaView(recetaId: 9, datos: DatosJson(
            id_usuario: 1,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
