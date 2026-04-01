import SwiftUI
import SwiftData

struct AjoutRepasView: View {
    @Bindable var journee: Journee
    @Query private var alimentsDisponibles: [Aliment]
    
    // Permet de fermer la fenêtre tout seul
    @Environment(\.dismiss) private var dismiss
    
    @State private var nomRepas = "Déjeuner"
    @State private var alimentsSelectionnes: [Aliment] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Nom du repas") {
                    TextField("Ex: Petit-déjeuner, Collation...", text: $nomRepas)
                }
                
                Section("Que contient ce repas ?") {
                    if alimentsDisponibles.isEmpty {
                        Text("Ta bibliothèque est vide. Ajoute des aliments dans l'onglet Nutrition d'abord.")
                            .foregroundStyle(.secondary)
                    } else {
                        // On liste tous tes aliments enregistrés
                        List(alimentsDisponibles) { aliment in
                            HStack {
                                Text(aliment.nom)
                                Spacer()
                                Text("\(aliment.proteines, specifier: "%.1f")g prot")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                // On affiche un petit check bleu si l'aliment est sélectionné
                                if alimentsSelectionnes.contains(aliment) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                        .padding(.leading, 10)
                                }
                            }
                            // Rend toute la ligne cliquable
                            .contentShape(Rectangle())
                            .onTapGesture {
                                // Si on clique, on ajoute ou on retire l'aliment de la liste
                                if alimentsSelectionnes.contains(aliment) {
                                    alimentsSelectionnes.removeAll { $0 == aliment }
                                } else {
                                    alimentsSelectionnes.append(aliment)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nouveau Repas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Valider") {
                        // On crée le repas et on l'ajoute à la journée !
                        let nouveauRepas = Repas(nom: nomRepas)
                        nouveauRepas.aliments = alimentsSelectionnes
                        journee.repas.append(nouveauRepas)
                        dismiss() // Ferme la fenêtre
                    }
                    // Le bouton est inactif si on n'a rien coché ou pas mis de nom
                    .disabled(nomRepas.isEmpty || alimentsSelectionnes.isEmpty)
                }
            }
        }
    }
}
