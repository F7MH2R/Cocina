import Foundation

// Modelo principal para la receta del usuario
struct RecetaUsuarioDetalle: Identifiable, Decodable {
    var id: Int { recetaIdentificador } // Conformidad con Identifiable utilizando recetaIdentificador
    let recetaIdentificador: Int
    let usuarioIdentificador: Int
    let descripcionDeLaReceta: String
    let cantidadPorciones: Int
    let tiempoDePreparacion: Int
    let enlaceDelVideo: String
    let fechaDeCreacion: String
    let ingredientesLista: [IngredienteUsuario]
    let creadorDeLaReceta: UsuarioCreador
    let resenasDeLaReceta: [ResenaUsuario]
    let categoriasDeLaReceta: [CategoriaDeReceta]
    let imagenesDeLaReceta: [ImagenReceta]
    let promedioCalificaciones: Double
    let totalDeResenas: Int
    let numeroDeVistas: Int

    enum CodingKeys: String, CodingKey {
        case recetaIdentificador = "id_receta"
        case usuarioIdentificador = "id_usuario"
        case descripcionDeLaReceta = "descripcion"
        case cantidadPorciones = "porciones"
        case tiempoDePreparacion = "tiempo"
        case enlaceDelVideo = "video"
        case fechaDeCreacion = "fecha"
        case ingredientesLista = "Ingredientes"
        case creadorDeLaReceta = "Usuarios"
        case resenasDeLaReceta = "Resena"
        case categoriasDeLaReceta = "TiposRecetas"
        case imagenesDeLaReceta = "Imagenes"
        case promedioCalificaciones = "promedioResenas"
        case totalDeResenas = "cantidadResenas"
        case numeroDeVistas = "vistas"
    }
}

// Modelo para el creador de la receta
struct UsuarioCreador: Decodable {
    let nombreDelCreador: String

    enum CodingKeys: String, CodingKey {
        case nombreDelCreador = "nombre"
    }
}

// Modelo para ingredientes
struct IngredienteUsuario: Decodable {
    let identificadorIngrediente: Int
    let recetaIdentificador: Int
    let nombreIngrediente: String

    enum CodingKeys: String, CodingKey {
        case identificadorIngrediente = "id_ingrediente"
        case recetaIdentificador = "id_receta"
        case nombreIngrediente = "ingrediente"
    }
}

// Modelo para reseñas
struct ResenaUsuario: Decodable {
    let calificacionValor: Int

    enum CodingKeys: String, CodingKey {
        case calificacionValor = "valor"
    }
}

// Modelo para categorías de recetas
struct CategoriaDeReceta: Decodable {
    let recetaIdentificador: Int
    let categoriaIdentificador: Int
    let detalleDeCategoria: DetalleDeCategoria

    enum CodingKeys: String, CodingKey {
        case recetaIdentificador = "id_receta"
        case categoriaIdentificador = "id_tipo"
        case detalleDeCategoria = "Tipos"
    }
}

// Modelo para detalles de categoría
struct DetalleDeCategoria: Decodable {
    let identificadorTipo: Int
    let nombreDeLaCategoria: String

    enum CodingKeys: String, CodingKey {
        case identificadorTipo = "id_tipo"
        case nombreDeLaCategoria = "nombre"
    }
}

// Modelo para imágenes de recetas
struct ImagenReceta: Decodable {
    let identificadorImagen: Int?
    let recetaIdentificador: Int?
    let enlaceDeLaImagen: String?

    enum CodingKeys: String, CodingKey {
        case identificadorImagen = "id_imagen"
        case recetaIdentificador = "id_receta"
        case enlaceDeLaImagen = "url_imagen"
    }
}
