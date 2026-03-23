// ==============================================================
// MyFitAppApp.swift
// Point d'entrée de l'application
//
// C'est le fichier que Xcode crée automatiquement. Tu dois juste
// remplacer son contenu par celui-ci pour brancher SwiftData.
// ==============================================================

import SwiftUI
import SwiftData

@main
struct MyFitAppApp: App {

    // Le 'container' est le moteur de sauvegarde SwiftData.
    // On lui indique toutes les classes (@Model) à gérer.
    // 'isStoredInMemoryOnly: false' = données persistantes (survit aux redémarrages).
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Programme.self,
            Exercice.self,
            Ressource.self,
            Session.self,
            SerieEffectuee.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Si le container ne peut pas être créé, l'app crashe avec un message clair.
            fatalError("Impossible de créer le ModelContainer : \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // ContentView sera la vue principale (TabView) — on la créera à l'étape 3
            ContentView()
        }
        // On injecte le container dans toute l'app.
        // Toutes les vues pourront accéder aux données via @Environment ou @Query.
        .modelContainer(sharedModelContainer)
    }
}
