import Foundation
import SwiftData

// MARK: - SPORT & SUIVI

@Model
class Programme {
    var nom: String
    var objectif: String
    @Relationship(deleteRule: .cascade) var seances: [Seance]
    
    init(nom: String, objectif: String) {
        self.nom = nom
        self.objectif = objectif
        self.seances = []
    }
}

@Model
class Seance {
    var nom: String
    var jourSemaine: String
    @Relationship(deleteRule: .cascade) var exercices: [ExerciceProgramme]
    
    init(nom: String, jourSemaine: String) {
        self.nom = nom
        self.jourSemaine = jourSemaine
        self.exercices = []
    }
}

@Model
class ExerciceProgramme {
    var nom: String
    var series: Int
    var reps: String
    var reposEnSecondes: Int // Stocké en secondes pour le chronomètre
    var note: String
    var imageData: Data? // Pour stocker ta photo
    @Relationship(deleteRule: .cascade) var performances: [Performance]
    
    init(nom: String, series: Int, reps: String, reposEnSecondes: Int, note: String = "") {
        self.nom = nom
        self.series = series
        self.reps = reps
        self.reposEnSecondes = reposEnSecondes
        self.note = note
        self.performances = []
    }
}

@Model
class Performance {
    var date: Date
    var charge: Double // ex: 80.0 kg
    var sensation: Int // Note sur 10
    
    init(date: Date, charge: Double, sensation: Int) {
        self.date = date
        self.charge = charge
        self.sensation = sensation
    }
}

// MARK: - NUTRITION & CALENDRIER

@Model
class Journee {
    @Attribute(.unique) var date: Date
    var consommationEau: Double
    @Relationship(deleteRule: .cascade) var repas: [Repas]
    
    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
        self.consommationEau = 0.0
        self.repas = []
    }
}

@Model
class Repas {
    var nom: String
    var aliments: [Aliment]
    
    init(nom: String) {
        self.nom = nom
        self.aliments = []
    }
}

@Model
class Aliment {
    var nom: String
    var calories: Int
    var proteines: Double
    
    init(nom: String, calories: Int, proteines: Double) {
        self.nom = nom
        self.calories = calories
        self.proteines = proteines
    }
}

@Model
class Ressource {
    var titre: String
    var url: String
    var categorie: String // ex: "Tuto", "Motivation", "Nutrition"
    
    init(titre: String, url: String, categorie: String = "Général") {
        self.titre = titre
        self.url = url
        self.categorie = categorie
    }
}
