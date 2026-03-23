// ==============================================================
// Models.swift
// MyFitApp — Couche de données (SwiftData)
//
// CE FICHIER contient toutes les classes de données de l'app.
// SwiftData est le système de sauvegarde d'Apple : chaque classe
// marquée @Model est automatiquement stockée sur l'iPhone.
// ==============================================================

import Foundation
import SwiftData

// --------------------------------------------------------------
// 1. PROGRAMME
//    Représente un programme d'entraînement (ex: "Push Day")
// --------------------------------------------------------------
@Model
final class Programme {

    // 'var' = modifiable après création. UUID = identifiant unique auto-généré.
    var id: UUID
    var nom: String
    var descriptionProgramme: String  // Optionnel : notes sur le programme

    // Relation One-to-Many : un Programme contient plusieurs Exercices.
    // 'cascade' = si on supprime le Programme, ses Exercices sont supprimés aussi.
    @Relationship(deleteRule: .cascade)
    var exercices: [Exercice]

    var dateCreation: Date

    init(nom: String, descriptionProgramme: String = "") {
        self.id = UUID()
        self.nom = nom
        self.descriptionProgramme = descriptionProgramme
        self.exercices = []
        self.dateCreation = Date()
    }
}

// --------------------------------------------------------------
// 2. EXERCICE
//    Représente un exercice dans la bibliothèque
//    (ex: "Développé couché")
// --------------------------------------------------------------
@Model
final class Exercice {

    var id: UUID
    var nom: String
    var descriptionExercice: String
    var groupeMusculaire: GroupeMusculaire  // Enum pour éviter les fautes

    // L'image est stockée en Data (bytes bruts).
    // Le '?' signifie qu'elle est optionnelle (l'exercice peut ne pas avoir d'image).
    var imageData: Data?

    // Paramètres par défaut de l'exercice
    var series: Int
    var repetitions: String  // String car on peut écrire "8-12" ou "Max"
    var poids: Double         // En kg
    var tempsRepos: Int       // ⏱ En secondes (ex: 90 pour 1min30) — AJOUT TIMER

    var dateCreation: Date

    init(
        nom: String,
        descriptionExercice: String = "",
        groupeMusculaire: GroupeMusculaire = .autre,
        series: Int = 3,
        repetitions: String = "10",
        poids: Double = 0.0,
        tempsRepos: Int = 90
    ) {
        self.id = UUID()
        self.nom = nom
        self.descriptionExercice = descriptionExercice
        self.groupeMusculaire = groupeMusculaire
        self.series = series
        self.repetitions = repetitions
        self.poids = poids
        self.tempsRepos = tempsRepos
        self.dateCreation = Date()
    }
}

// Enum = liste de valeurs fixes. Ça évite les erreurs de frappe
// et permet de filtrer proprement dans la bibliothèque.
// 'String' = chaque cas a un nom lisible. 'Codable' = peut être sauvegardé.
enum GroupeMusculaire: String, Codable, CaseIterable {
    case poitrine    = "Poitrine"
    case dos         = "Dos"
    case epaules     = "Épaules"
    case biceps      = "Biceps"
    case triceps     = "Triceps"
    case jambes      = "Jambes"
    case abdominaux  = "Abdominaux"
    case autre       = "Autre"
}

// --------------------------------------------------------------
// 3. RESSOURCE
//    Liens YouTube ou articles de référence
// --------------------------------------------------------------
@Model
final class Ressource {

    var id: UUID
    var titre: String

    // On stocke l'URL en String car SwiftData ne supporte pas
    // directement le type URL. On la convertit quand on en a besoin.
    var urlString: String

    // Propriété calculée (non stockée) : convertit le String en URL
    // Le 'var' sans stockage = recalculé à chaque accès, jamais sauvegardé.
    var url: URL? {
        URL(string: urlString)
    }

    var dateAjout: Date

    init(titre: String, urlString: String) {
        self.id = UUID()
        self.titre = titre
        self.urlString = urlString
        self.dateAjout = Date()
    }
}

// --------------------------------------------------------------
// 4. SESSION  (AJOUT — Mode séance en temps réel)
//    Enregistre chaque séance effectuée pour l'historique
// --------------------------------------------------------------
@Model
final class Session {

    var id: UUID
    var dateSeance: Date

    // On garde une référence au nom du programme (pas l'objet directement)
    // pour éviter les problèmes si le programme est supprimé plus tard.
    var nomProgramme: String

    // Liste des séries effectuées pendant la séance
    @Relationship(deleteRule: .cascade)
    var seriesEffectuees: [SerieEffectuee]

    // Durée totale de la séance en secondes
    var dureeTotale: Int

    init(nomProgramme: String) {
        self.id = UUID()
        self.dateSeance = Date()
        self.nomProgramme = nomProgramme
        self.seriesEffectuees = []
        self.dureeTotale = 0
    }
}

// Sous-modèle pour enregistrer chaque série dans une session
@Model
final class SerieEffectuee {

    var id: UUID
    var nomExercice: String
    var numeroSerie: Int
    var repetitionsRealisees: Int
    var poidsUtilise: Double

    init(nomExercice: String, numeroSerie: Int, repetitionsRealisees: Int, poidsUtilise: Double) {
        self.id = UUID()
        self.nomExercice = nomExercice
        self.numeroSerie = numeroSerie
        self.repetitionsRealisees = repetitionsRealisees
        self.poidsUtilise = poidsUtilise
    }
}
