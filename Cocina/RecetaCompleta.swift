import Foundation

// Modelo principal para la receta
// Modelo principal para la receta
struct DetalleReceta: Identifiable, Decodable {
    var id: Int { recetaId } // Conformidad con Identifiable utilizando recetaId
    let recetaId: Int
    let usuarioId: Int
    let recetaDescripcion: String
    let numeroPorciones: Int
    let tiempoPreparacion: Int
    let enlaceVideo: String
    let fechaCreacion: String
    let listaIngredientes: [Componente]
    let autorReceta: Autor
    let listaResenas: [Calificacion]
    let categoriasReceta: [CategoriaReceta]
    let galeriaImagenes: [Foto]
    let calificacionPromedio: Double
    let totalResenas: Int
    let contadorVistas: Int

    enum CodingKeys: String, CodingKey {
        case recetaId = "id_receta"
        case usuarioId = "id_usuario"
        case recetaDescripcion = "descripcion"
        case numeroPorciones = "porciones"
        case tiempoPreparacion = "tiempo"
        case enlaceVideo = "video"
        case fechaCreacion = "fecha"
        case listaIngredientes = "Ingredientes"
        case autorReceta = "Usuarios"
        case listaResenas = "Resena"
        case categoriasReceta = "TiposRecetas"
        case galeriaImagenes = "Imagenes"
        case calificacionPromedio = "promedioResenas"
        case totalResenas = "cantidadResenas"
        case contadorVistas = "vistas"
    }
}


// Modelo para el usuario
struct Autor: Decodable {
    let nombreAutor: String

    enum CodingKeys: String, CodingKey {
        case nombreAutor = "nombre"
    }
}

// Modelo para ingredientes
struct Componente: Decodable {
    let ingredienteId: Int
    let recetaId: Int
    let ingredienteNombre: String

    enum CodingKeys: String, CodingKey {
        case ingredienteId = "id_ingrediente"
        case recetaId = "id_receta"
        case ingredienteNombre = "ingrediente"
    }
}

// Modelo para reseñas
struct Calificacion: Decodable {
    let valorCalificacion: Int

    enum CodingKeys: String, CodingKey {
        case valorCalificacion = "valor"
    }
}

// Modelo para tipos de recetas
struct CategoriaReceta: Decodable {
    let recetaId: Int
    let categoriaId: Int
    let detalleCategoria: Categoria

    enum CodingKeys: String, CodingKey {
        case recetaId = "id_receta"
        case categoriaId = "id_tipo"
        case detalleCategoria = "Tipos"
    }
}

// Modelo para tipos
struct Categoria: Decodable {
    let tipoId: Int
    let nombreCategoria: String

    enum CodingKeys: String, CodingKey {
        case tipoId = "id_tipo"
        case nombreCategoria = "nombre"
    }
}

// Modelo para imágenes
struct Foto: Decodable {
    let fotoId: Int
    let recetaId: Int
    let enlaceImagen: String

    enum CodingKeys: String, CodingKey {
        case fotoId = "id_imagen"
        case recetaId = "id_receta"
        case enlaceImagen = "url_imagen"
    }
}
