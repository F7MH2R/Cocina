import SwiftUI

struct PerfilView: View {
    let datos: DatosJson
    @State private var nombreReal = "Kevin Daniel Rodríguez Martínez"
    @State private var nickname = "Dani Marinadez"
    @State private var email = "Marinadaestofa@gmail.com"
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?

    // Estados para los modos de edición
    @State private var isEditing = false // Modo de edición activado/desactivado

    // ID del usuario (debería ser dinámico)

    var body: some View {
        VStack {
            EncabezadoView(nickname: datos.usuario, nombre: datos.nombre)
            
            Text("Perfil")
                .font(.title)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 16) {
                // Campo de Nombre Real
                Text("Nombre Real:")
                    .font(.headline)
                if isEditing {
                    TextField("Editar Nombre Real", text: $nombreReal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(nombreReal)
                        .font(.body)
                }
                
                // Campo de Nickname
                Text("Nickname:")
                    .font(.headline)
                if isEditing {
                    TextField("Editar Nickname", text: $nickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(nickname)
                        .font(.body)
                }
                
                // Campo de Correo
                Text("Correo:")
                    .font(.headline)
                if isEditing {
                    TextField("Editar Correo", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                } else {
                    Text(email)
                        .font(.body)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Botón para alternar el modo de edición y guardar cambios
            Button(action: {
                if isEditing {
                    editarUsuario()
                }
                isEditing.toggle() // Alternar entre editar y no editar
            }) {
                Text(isEditing ? "Guardar Cambios" : "Editar Información")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isEditing ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // Campo de cambio de contraseña
            VStack(spacing: 16) {
                SecureField("Contraseña Actual", text: $oldPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                SecureField("Nueva Contraseña", text: $newPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    cambiarContrasena()
                }) {
                    Text("Cambiar Contraseña")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.caption)
            }
            
            Spacer()
        }
        .background(Color(.systemGreen).opacity(0.1))
        .ignoresSafeArea(edges: .top)
        .onAppear{CargarUser()}
    }
    func CargarUser() {
        nickname = datos.usuario
        nombreReal = datos.nombre
        email = datos.correo
    }
    
    // Función para editar el usuario
    func editarUsuario() {
        guard let url = URL(string: "\(Constants.API.baseURL)/edituser/\(datos.id_usuario)") else {
            errorMessage = "URL inválida"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "correo": email,
            "nombre": nombreReal,
            "usuario": nickname
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errorMessage = "Error de red al editar usuario"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    successMessage = "Usuario actualizado correctamente"
                    errorMessage = nil
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Error al actualizar el usuario"
                }
            }
        }.resume()
    }
    
    // Función para cambiar la contraseña
    func cambiarContrasena() {
        guard let url = URL(string: "\(Constants.API.baseURL)/changepass/\(datos.id_usuario)") else {
            errorMessage = "URL inválida"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "oldpassword": oldPassword,
            "newpassword": newPassword
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errorMessage = "Error de red al cambiar contraseña"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    successMessage = "Contraseña actualizada correctamente"
                    errorMessage = nil
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Error al cambiar contraseña"
                }
            }
        }.resume()
    }
}

struct PerfilView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView(datos: DatosJson(
            id_usuario: 14,
            correo: "usuario@example.com",
            nombre: "Dani Martinez",
            usuario: "dani123"
        ))
    }
}
