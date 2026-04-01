import SwiftUI
import SwiftData

struct ProgrammeDetailView: View {
    // @Bindable permet de modifier directement ce programme précis
    @Bindable var programme: Programme
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            if programme.seances.isEmpty {
                ContentUnavailableView(
                    "Aucune Séance",
                    systemImage: "calendar.badge.plus",
                    description: Text("Ajoute tes jours d'entraînement (ex: Lundi - Poitrine + Triceps).")
                )
            } else {
                ForEach(programme.seances) { seance in
                                    // On ajoute le lien de navigation ici
                                    NavigationLink(destination: SeanceDetailView(seance: seance)) {
                                        VStack(alignment: .leading) {
                                            Text(seance.nom)
                                                .font(.headline)
                                            Text(seance.jourSemaine)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                .onDelete(perform: supprimerSeance)
            }
        }
        .navigationTitle(programme.nom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: ajouterSeanceTest) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    // MARK: - Fonctions
    
    private func ajouterSeanceTest() {
        // On crée une séance test basée sur ton PDF
        let nouvelleSeance = Seance(nom: "Poitrine + Triceps", jourSemaine: "Lundi")
        // On l'ajoute directement au programme en cours !
        programme.seances.append(nouvelleSeance)
    }
    
    private func supprimerSeance(offsets: IndexSet) {
        for index in offsets {
            let seance = programme.seances[index]
            context.delete(seance)
        }
    }
}
