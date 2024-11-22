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

    var body: some View {
        NavigationView {
            VStack {
                // Encabezado y nombre de la receta
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
                    // Ingredientes
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

                    // Procedimientos
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

                    // Imagen y datos
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

                // Botón Publicar
                Button(action: {
                    print("Porciones: \(porciones), Tiempo: \(tiempo)")
                }) {
                    Text("Publicar")
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
                Text("Editar")
                    .font(.headline)
                TextField("Texto", text: $editingText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    Button("Guardar", action: {
                        if let index = editingIndex {
                            if isEditingIngredient {
                                ingredientes[index] = editingText
                            } else {
                                pasos[index] = editingText
                            }
                            editingIndex = nil
                            editMode = false
                        }
                    })
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)

                    Button("Cancelar", action: {
                        editingIndex = nil
                        editMode = false
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
            id_usuario: 1,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
