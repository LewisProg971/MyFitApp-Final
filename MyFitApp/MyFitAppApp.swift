import SwiftUI
import SwiftData

@main
struct MyFitAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // On repasse en 100% local, sans iCloud
        .modelContainer(for: [
            Programme.self,
            Seance.self,
            ExerciceProgramme.self,
            Performance.self,
            Journee.self,
            Repas.self,
            Aliment.self,
            Ressource.self
        ])
    }
}
