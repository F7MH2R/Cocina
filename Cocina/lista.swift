import SwiftUI

struct ListaIngredientesView: View {
    @State private var ingredientes: [IngredienteModel] = [] // Lista de ingredientes
    @State private var searchText: String = "" // Texto de búsqueda
    @State private var isLoading: Bool = true // Estado de carga
    @State private var errorMessage: String? // Mensaje de error
    @State private var showToast = false // Estado para el toast
    @State private var toastMessage = "" // Mensaje del toast

    let userId: Int // ID del usuario

    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)

            VStack {
                // Campo de búsqueda
                HStack {
                    TextField("Buscar Ingrediente", text: $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .onChange(of: searchText) { _ in
                            fetchIngredientes()
                        }
                    Image(systemName: "magnifyingglass")
                        .padding()
                        .foregroundColor(.gray)
                }
                .padding()

                if isLoading {
                    // Indicador de carga
                    ProgressView("Cargando ingredientes...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    // Mostrar mensaje de error
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Lista de ingredientes
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(ingredientes) { ingrediente in
                                HStack {
                                    Text(ingrediente.item)
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Button(action: {
                                        eliminarIngrediente(id: ingrediente.id_lista)
                                    }) {
                                        Image(systemName: "delete.left.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            // Toast de confirmación
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
            fetchIngredientes()
        }
        .navigationTitle("Lista de ingredientes")
    }

    // Función para cargar los ingredientes
    func fetchIngredientes() {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/obtenerlista/\(userId)?nombre=\(searchText)") else {
            errorMessage = "URL inválida"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

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
                let decodedData = try JSONDecoder().decode([IngredienteModel].self, from: data)
                DispatchQueue.main.async {
                    ingredientes = decodedData
                    isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Error al decodificar datos: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }.resume()
    }

    // Función para eliminar un ingrediente
    func eliminarIngrediente(id: Int) {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/eliminaritem/\(id)") else {
            errorMessage = "URL inválida"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    ingredientes.removeAll { $0.id_lista == id }
                    toastMessage = "Elemento eliminado correctamente"
                    showToast = true
                }
            } else {
                DispatchQueue.main.async {
                    toastMessage = "Error al eliminar el elemento"
                    showToast = true
                }
            }
        }.resume()
    }
}

// Modelo de Ingrediente
struct IngredienteModel: Identifiable, Decodable {
    let id_lista: Int
    let id_usuario: Int
    let item: String
    
    // Identificador único para la lista de SwiftUI
    var id: Int { id_lista }
}


struct ListaIngredientesView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredientesView(userId: 1)
    }
}
