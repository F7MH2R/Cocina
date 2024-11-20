import Foundation

// Modelo para la receta
struct Receta: Identifiable, Decodable {
    let id: Int
    let descripcion: String
    let porciones: Int
    let tiempo: Int
    let video: String
    let fecha: String
    let Usuarios: Usuario
    let promedioResenas: Double
    let cantidadResenas: Int
    let vistas: Int
    let Ingredientes: [Ingrediente]
    let Resena: [Resena]
    let TiposRecetas: [TipoReceta]
    let Imagenes: [Imagen]

    // Mapeo de claves para el decodificador
    enum CodingKeys: String, CodingKey {
        case id = "id_receta"
        case descripcion, porciones, tiempo, video, fecha, Usuarios, promedioResenas, cantidadResenas, vistas
        case Ingredientes, Resena, TiposRecetas, Imagenes
    }
}

// Modelo para el usuario
struct Usuario: Decodable {
    let nombre: String
}

// Modelo para la imagen
struct Imagen: Decodable {
    let url_imagen: String
}

// Modelo para ingredientes
struct Ingrediente: Decodable {
    let id_ingrediente: Int
    let id_receta: Int
    let ingrediente: String
}

// Modelo para reseñas
struct Resena: Decodable {
    let id_resena: Int
    let id_receta: Int
    let id_usuario: Int
    let valor: Int
}

// Modelo para tipos de recetas
struct TipoReceta: Decodable {
    let id_receta: Int
    let id_tipo: Int
    let Tipos: Tipo
}

// Modelo para tipos
struct Tipo: Decodable {
    let id_tipo: Int
    let nombre: String
}

