import SwiftUI
import SwiftData

@main
struct MyFitAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // C'est cette ligne qui active la base de données pour toute l'app !
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
