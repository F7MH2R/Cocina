import SwiftUI

struct CrearCuentaView: View {
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var message: String = ""
    @State private var isAccountCreated: Bool = false // Control de navegación

    var body: some View {
        NavigationView {
            ZStack {
                // Fondo verde
                Color(red: 224 / 255, green: 255 / 255, blue: 224 / 255)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Título
                    VStack {
                        Text("CREA TU")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("CUENTA")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(Color.pink)

                    Spacer().frame(height: 20)

                    // Campos de entrada
                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "Correo", text: $email)
                        CustomTextField(placeholder: "Nombre Completo", text: $fullName)
                        CustomTextField(placeholder: "Nombre de Usuario", text: $username)
                        SecureFieldWithToggle(placeholder: "Contraseña", text: $password, showPassword: $showPassword)
                        SecureFieldWithToggle(placeholder: "Repita Contraseña", text: $confirmPassword, showPassword: $showConfirmPassword)
                    }
                    .padding(.horizontal, 30)

                    Spacer().frame(height: 40)

                    // Botón de Crear Cuenta
                    Button(action: {
                        crearCuenta()
                    }) {
                        Text("Crear Cuenta")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)

                    Spacer()

                    // Mensaje de estado
                    if !message.isEmpty {
                        Text(message)
                            .foregroundColor(message.contains("éxito") ? .green : .red)
                            .padding(.top, 10)
                    }

                    // Navegación a ContentView
                    NavigationLink(
                        destination: ContentView(),
                        isActive: $isAccountCreated
                    ) {
                        EmptyView()
                    }
                }
            }
        }
    }

    // Función para realizar la solicitud HTTP POST
    func crearCuenta() {
        // Validaciones básicas
        guard !email.isEmpty, email.contains("@"), email.contains(".") else {
            self.message = "Por favor, ingresa un correo válido."
            return
        }
        
        guard !fullName.isEmpty else {
            self.message = "El nombre completo no puede estar vacío."
            return
        }
        
        guard !username.isEmpty else {
            self.message = "El nombre de usuario no puede estar vacío."
            return
        }
        
        guard password.count >= 6 else {
            self.message = "La contraseña debe tener al menos 6 caracteres."
            return
        }
        
        guard password == confirmPassword else {
            self.message = "Las contraseñas no coinciden."
            return
        }

        // URL de la API
        guard let url = URL(string: "\(Constants.API.baseURL)/createuser") else {
            self.message = "URL no válida."
            return
        }

        // Crear el cuerpo de la solicitud
        let body: [String: Any] = [
            "correo": email,
            "nombre": fullName,
            "usuario": username,
            "contrasena": password
        ]

        // Convertir el cuerpo a JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            self.message = "Error al crear JSON."
            return
        }

        // Configuración de la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Llamada HTTP
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.message = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.message = "Error en el servidor."
                }
                return
            }

            DispatchQueue.main.async {
                self.isAccountCreated = true // Marca la cuenta como creada para redirigir
                self.message = "Cuenta creada con éxito. Redirigiendo..."
            }
        }.resume()
    }
}

// Campo de texto personalizado
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .autocapitalization(.none) // Evita la capitalización automática
            .disableAutocorrection(true) // Desactiva la corrección automática
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

// Campo de contraseña con botón para mostrar/ocultar
struct SecureFieldWithToggle: View {
    var placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        HStack {
            if showPassword {
                TextField(placeholder, text: $text)
                    .padding()
            } else {
                SecureField(placeholder, text: $text)
                    .padding()
            }
            Button(action: {
                showPassword.toggle()
            }) {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 10)
        }
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct CrearCuentaView_Previews: PreviewProvider {
    static var previews: some View {
        CrearCuentaView()
    }
}
