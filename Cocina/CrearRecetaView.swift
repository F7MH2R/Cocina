import SwiftUI

struct CrearRecetaView: View {
    
    let datos: DatosJson
    @State private var nombreReceta: String = "Mi Nueva Receta"
    @State private var ingredientes: [String] = ["Una taza de Harina de trigo", "Una taza de Maicena", "4 Huevos"]
    @State private var pasos: [String] = ["Agrega la harina y el agua hasta lograr una masa espesa y profunda.",
                                          "Cocina el pollo y las papas en una olla con agua a fuego lento durante unos 40-50 minutos."]
    @State private var linkVideo: String = ""
    @State private var porciones: String = ""
    @State private var imagenReceta: UIImage? = nil
    @State private var showAddIngrediente = false
    @State private var showAddPaso = false
    @State private var nuevoIngrediente: String = ""
    @State private var nuevoPaso: String = ""

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

                        ForEach(ingredientes, id: \.self) { ingrediente in
                            HStack {
                                Text(ingrediente)
                                    .font(.body)
                                Spacer()
                                Menu {
                                    Button("Editar", action: {
                                        // Acción para editar
                                    })
                                    Button("Eliminar", action: {
                                        if let index = ingredientes.firstIndex(of: ingrediente) {
                                            ingredientes.remove(at: index)
                                        }
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

                        ForEach(Array(pasos.enumerated()), id: \.offset) { index, paso in
                            HStack {
                                Text("\(index + 1). \(paso)")
                                    .font(.body)
                                Spacer()
                                Menu {
                                    Button("Editar", action: {
                                        // Acción para editar
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
                            // Acción para subir imagen
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title)
                                .foregroundColor(.pink)
                        }

                        TextField("Link del video (opcional)", text: $linkVideo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical)

                        TextField("Porciones", text: $porciones)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.vertical)
                    }
                    .padding()
                }

                // Botón Publicar
                Button(action: {
                    // Acción para publicar receta
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
