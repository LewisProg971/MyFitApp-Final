import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            // Tab 1 : Calendrier
            // Tab 1 : Calendrier
                        CalendrierView()
                            .tabItem {
                                Label("Calendrier", systemImage: "calendar")
                            }
            
            // Tab 2 : Entraînement (Sport)
            SportView()
                .tabItem {
                    Label("Sport", systemImage: "figure.strengthtraining.traditional")
                }
            
            // Tab 3 : Nutrition
                        NutritionView()
                            .tabItem {
                                Label("Nutrition", systemImage: "fork.knife")
                            }
            
            // Tab 4 : Ressources
            RessourcesView()
                .tabItem {
                    Label("Ressources", systemImage: "play.tv")
                }
        }
        // Pour être sûr que la barre s'affiche bien visuellement
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
