import SwiftUI

struct EncabezadoView: View {
    var nickname: String
    var nombre: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(nickname)
                .font(.title)
                .foregroundColor(.white)
            Text(nombre)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.green)
    }
}
