import SwiftUI

struct PerfilView: View {
    @State private var nombreReal = "Kevin Daniel Rodríguez Martínez"
    @State private var nickname = "Dani Marinadez"
    @State private var email = "Marinadaestofa@gmail.com"
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        VStack {
            EncabezadoView(nickname: nickname, nombre: nombreReal)
            
            Text("Perfil")
                .font(.title)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Nombre Real:")
                    .font(.headline)
                Text(nombreReal)
                    .font(.body)
                
                Text("Nickname:")
                    .font(.headline)
                Text(nickname)
                    .font(.body)
                
                Text("Correo:")
                    .font(.headline)
                Text(email)
                    .font(.body)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                Button(action: {
                    // Acción para editar datos
                }) {
                    Text("Editar Datos")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
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
                    // Acción para cambiar contraseña
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
    }
}

struct PerfilView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView()
    }
}
