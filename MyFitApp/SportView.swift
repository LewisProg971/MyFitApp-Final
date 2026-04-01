import SwiftUI
import SwiftData

struct SportView: View {
    // 1. On interroge la base de données pour récupérer tous les programmes
    @Query var programmes: [Programme]
    
    // 2. On récupère le "contexte" pour pouvoir ajouter/supprimer des choses
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                // S'il n'y a pas de programme, on affiche un petit message
                if programmes.isEmpty {
                    ContentUnavailableView(
                        "Aucun Programme",
                        systemImage: "dumbbell",
                        description: Text("Appuie sur le + pour ajouter ton premier programme d'entraînement.")
                    )
                } else {
                    // Sinon, on liste les programmes
                    ForEach(programmes) { programme in
                                            // C'est cette ligne qui crée la "flèche" pour changer d'écran
                                            NavigationLink(destination: ProgrammeDetailView(programme: programme)) {
                                                VStack(alignment: .leading) {
                                                    Text(programme.nom)
                                                        .font(.headline)
                                                    Text(programme.objectif)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                            }
                                        }
                    // Permet de supprimer un programme en glissant vers la gauche
                    .onDelete(perform: supprimerProgramme)
                }
            }
            .navigationTitle("Mes Programmes")
            .toolbar {
                // Bouton + en haut à droite
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: ajouterProgrammeTest) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    // MARK: - Fonctions
    
    // Fonction temporaire pour tester l'ajout
    private func ajouterProgrammeTest() {
        let nouveauProgramme = Programme(nom: "Lewis - Retour à la salle", objectif: "Force & Prise de masse")
        context.insert(nouveauProgramme)
    }
    
    private func supprimerProgramme(offsets: IndexSet) {
        for index in offsets {
            context.delete(programmes[index])
        }
    }
}

#Preview {
    SportView()
        // Permet à la Preview de fonctionner avec SwiftData
        .modelContainer(for: Programme.self, inMemory: true)
}
