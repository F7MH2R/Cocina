import SwiftUI

struct CrearRecetaView: View {
    let datos: DatosJson
    @State private var nombreReceta: String = "Mi Nueva Receta"
    @State private var ingredientes: [String] = ["Una taza de Harina de trigo", "Una taza de Maicena", "4 Huevos"]
    @State private var pasos: [String] = ["Agrega la harina y el agua hasta lograr una masa espesa y profunda.",
                                          "Cocina el pollo y las papas en una olla con agua a fuego lento durante unos 40-50 minutos."]
    @State private var linkVideo: String = ""
    @State private var porciones: Int = 0
    @State private var tiempo: Int = 0
    @State private var imagenReceta: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var showAddIngrediente = false
    @State private var showAddPaso = false
    @State private var nuevoIngrediente: String = ""
    @State private var nuevoPaso: String = ""
    @State private var editMode: Bool = false
    @State private var editingIndex: Int? = nil
    @State private var editingText: String = ""
    @State private var isEditingIngredient: Bool = false
    @State private var recetaId: Int? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Cargando...")
                        .padding()
                }

                VStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            // Acción para volver
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        Text("Crear Receta")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()

                    TextField("Mi Nueva Receta", text: $nombreReceta)
                        .font(.title2)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .background(Color.green)
                .foregroundColor(.white)

                ScrollView {
                    // Lista de Ingredientes
                    VStack(alignment: .leading) {
                        Text("LISTA DE INGREDIENTES")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .padding(.bottom, 5)

                        ForEach(ingredientes.indices, id: \.self) { index in
                            HStack {
                                Text(ingredientes[index])
                                    .font(.body)
                                Spacer()
                                Menu {
                                    Button("Editar", action: {
                                        startEditing(index: index, isIngredient: true)
                                    })
                                    Button("Eliminar", action: {
                                        ingredientes.remove(at: index)
                                    })
                                } label: {
                                    Image(systemName: "ellipsis.circle")
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

                    Divider()

                    // Lista de Pasos
                    VStack(alignment: .leading) {
                        Text("PASOS A SEGUIR")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .padding(.bottom, 5)

                        ForEach(pasos.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1). \(pasos[index])")
                                    .font(.body)
                                Spacer()
                                Menu {
                                    Button("Editar", action: {
                                        startEditing(index: index, isIngredient: false)
                                    })
                                    Button("Eliminar", action: {
                                        pasos.remove(at: index)
                                    })
                                    Button("Subir", action: {
                                        if index > 0 {
                                            pasos.swapAt(index, index - 1)
                                        }
                                    })
                                    Button("Bajar", action: {
                                        if index < pasos.count - 1 {
                                            pasos.swapAt(index, index + 1)
                                        }
                                    })
                                } label: {
                                    Image(systemName: "ellipsis.circle")
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

                    Divider()

                    // Imagen y otros detalles
                    VStack(alignment: .leading) {
                        Text("Imagen de la receta")
                            .font(.headline)

                        if let imagen = imagenReceta {
                            Image(uiImage: imagen)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipped()
                        } else {
                            Color.gray
                                .frame(height: 150)
                                .overlay(
                                    Text("Sin imagen")
                                        .foregroundColor(.white)
                                )
                        }

                        Button(action: {
                            showImagePicker.toggle()
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title)
                                .foregroundColor(.pink)
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: $imagenReceta)
                        }

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
                    }
                    .padding()
                }

                // Botón para guardar receta
                Button(action: saveReceta) {
                    Text("Guardar Receta")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding()

            }
        }
        .sheet(isPresented: $editMode) {
            VStack {
                Text(isEditingIngredient ? "Editar Ingrediente" : "Editar Paso")
                    .font(.headline)
                    .padding()

                TextField("Nuevo texto", text: $editingText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack {
                    Button("Guardar") {
                        saveEdit()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)

                    Button("Cancelar") {
                        cancelEdit()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    func saveReceta() {
        isLoading = true

        let recetaData: [String: Any] = [
            "descripcion": nombreReceta,
            "id_usuario": datos.id_usuario,
            "porciones": porciones,
            "video": "No URL",
            "tiempo": tiempo,
            "Ingredientes": ingredientes,
            "Pasos": pasos.enumerated().map { ["paso": $1, "orden": $0 + 1] }
        ]

        guard let url = URL(string: "\(Constants.API.baseURL)/createreceta") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: recetaData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = response as? [String: Any], let id = json["id_receta"] as? Int {
                    DispatchQueue.main.async {
                        recetaId = id
                        uploadImage()
                    }
                }
            } catch {
                print("Error al procesar respuesta: \(error.localizedDescription)")
            }
        }.resume()
    }

    func uploadImage() {
        guard let recetaId = recetaId, let imageData = imagenReceta?.jpegData(compressionQuality: 0.8) else { return }

        let boundary = UUID().uuidString
        let url = URL(string: "\(Constants.API.baseURL)/subir/\(recetaId)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"imagenes\"; filename=\"receta.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("Error al subir imagen: \(error.localizedDescription)")
                return
            }

            print("Imagen subida correctamente.")
        }.resume()
    }

    func saveEdit() {
        guard let index = editingIndex else { return }
        if isEditingIngredient {
            ingredientes[index] = editingText
        } else {
            pasos[index] = editingText
        }
        cancelEdit()
    }

    func cancelEdit() {
        editingIndex = nil
        editingText = ""
        editMode = false
    }

    func startEditing(index: Int, isIngredient: Bool) {
        editingIndex = index
        editingText = isIngredient ? ingredientes[index] : pasos[index]
        isEditingIngredient = isIngredient
        editMode = true
    }
}

// Representable para ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct CrearRecetaView_Previews: PreviewProvider {
    static var previews: some View {
        CrearRecetaView(datos: DatosJson(
            id_usuario: 14,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
