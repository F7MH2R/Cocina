import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        ZStack {
            Color(red: 0.8, green: 0, blue: 0) // Fondo rojo para los bordes
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Logo
                Image("logo") // Reemplaza con el nombre correcto de la imagen
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 10)

                // Title and Subtitle
                Text("CHEFLIM")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.red)
                
                Text("RECETAS")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)

                // Input fields
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Contraseña", text: $password)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }
                .padding(.horizontal, 30)

                // Login Button
                Button(action: {
                    login()
                }) {
                    Text("Iniciar Sesión")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.8, green: 0, blue: 0)) // Color rojo del botón
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)

                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 5)
                }
                
                // Success message
                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.caption)
                        .padding(.top, 5)
                }

                // Register link
                HStack {
                    Text("¿No tienes cuenta?")
                    NavigationLink(destination: RegisterView()) {
                        Text("Crea una")
                            .foregroundColor(Color(red: 0.3, green: 0.8, blue: 0.3))
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .background(Color(red: 0.95, green: 1.0, blue: 0.95)) // Fondo verde claro
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
        .navigationBarHidden(true)
    }

    // Login function to consume API
    func login() {
        guard let url = URL(string: "https://tbk4n0cz-3000.use2.devtunnels.ms/api/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["correo": email, "contrasena": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error de red"
                    self.successMessage = nil
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    // Asume que la respuesta contiene un token o similar en JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Login exitoso: \(json)")
                    
                    DispatchQueue.main.async {
                        self.errorMessage = nil
                        self.successMessage = "Inicio de sesión exitoso"
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error de respuesta"
                        self.successMessage = nil
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Credenciales incorrectas"
                    self.successMessage = nil
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RegisterView: View {
    var body: some View {
        Text("Pantalla de Registro")
    }
}
