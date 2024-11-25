import SwiftUI

struct RecetaCardView: View {
    var titulo: String
    var autor: String
    var rating: Double
    
    var body: some View {
        HStack {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding()
            
            VStack(alignment: .leading) {
                Text(titulo)
                    .font(.headline)
                Text(autor)
                    .font(.subheadline)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(rating, specifier: "%.1f")")
                        .font(.subheadline)
                }
            }
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
