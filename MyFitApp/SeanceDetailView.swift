import SwiftUI
import SwiftData

struct SeanceDetailView: View {
    @Bindable var seance: Seance
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            if seance.exercices.isEmpty {
                ContentUnavailableView(
                    "Aucun Exercice",
                    systemImage: "figure.strengthtraining.traditional",
                    description: Text("Ajoute les exercices de ta séance.")
                )
            } else {
                ForEach(seance.exercices) { exercice in
                                    // Ajout du lien vers le nouvel écran
                                    NavigationLink(destination: ExerciceExecutionView(exercice: exercice)) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(exercice.nom)
                                                .font(.headline)
                                            
                                            HStack {
                                                Text("\(exercice.series) Séries")
                                                Text("•")
                                                Text("\(exercice.reps) Reps")
                                                Text("•")
                                                Text("\(exercice.reposEnSecondes)s repos")
                                            }
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            
                                            if !exercice.note.isEmpty {
                                                Text(exercice.note)
                                                    .font(.caption2)
                                                    .foregroundStyle(.blue)
                                                    .italic()
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                .onDelete(perform: supprimerExercice)
            }
        }
        .navigationTitle(seance.nom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: ajouterExerciceTest) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    // MARK: - Fonctions
    
    private func ajouterExerciceTest() {
        // On crée le premier exercice de ton PDF !
        let nouvelExercice = ExerciceProgramme(
            nom: "Développé couché barre",
            series: 4,
            reps: "8-12",
            reposEnSecondes: 90, // 1min30 = 90 secondes
            note: "Commence léger pour les 2 premières semaines."
        )
        seance.exercices.append(nouvelExercice)
    }
    
    private func supprimerExercice(offsets: IndexSet) {
        for index in offsets {
            let exercice = seance.exercices[index]
            context.delete(exercice)
        }
    }
}
