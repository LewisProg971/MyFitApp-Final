import SwiftUI
import SwiftData

struct NutritionView: View {
    @Query private var aliments: [Aliment]
    @Environment(\.modelContext) private var context
    
    // États pour le formulaire d'ajout (Sheet)
    @State private var montrantAjout = false
    @State private var nomSaisi = ""
    @State private var caloriesSaisies = ""
    @State private var proteinesSaisies = ""
    
    var body: some View {
        NavigationStack {
            List {
                if aliments.isEmpty {
                    ContentUnavailableView(
                        "Aucun Aliment",
                        systemImage: "carrot",
                        description: Text("Ajoute tes aliments fréquents (ex: Poulet, Riz, Whey) pour suivre tes protéines.")
                    )
                } else {
                    ForEach(aliments) { aliment in
                        HStack {
                            Text(aliment.nom)
                                .font(.headline)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(aliment.calories) kcal")
                                    .bold()
                                Text("\(aliment.proteines, specifier: "%.1f")g Prot")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: supprimerAliment)
                }
            }
            .navigationTitle("Ma Bibliothèque")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { montrantAjout.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            // La fenêtre glissante pour ajouter un aliment
            .sheet(isPresented: $montrantAjout) {
                NavigationStack {
                    Form {
                        Section("Détails de l'aliment (pour 100g ou 1 portion)") {
                            TextField("Nom (ex: Blanc de poulet)", text: $nomSaisi)
                            
                            TextField("Calories (kcal)", text: $caloriesSaisies)
                                .keyboardType(.numberPad)
                            
                            TextField("Protéines (g)", text: $proteinesSaisies)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .navigationTitle("Nouvel Aliment")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") { montrantAjout = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Ajouter") {
                                ajouterAliment()
                            }
                            // On désactive le bouton si le nom est vide
                            .disabled(nomSaisi.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium]) // Rend la fenêtre plus petite (moitié d'écran)
            }
        }
    }
    
    // MARK: - Fonctions
    
    private func ajouterAliment() {
        let cal = Int(caloriesSaisies) ?? 0
        // On remplace la virgule par un point au cas où le clavier iOS mette une virgule
        let protString = proteinesSaisies.replacingOccurrences(of: ",", with: ".")
        let prot = Double(protString) ?? 0.0
        
        let nouvelAliment = Aliment(nom: nomSaisi, calories: cal, proteines: prot)
        context.insert(nouvelAliment)
        
        // On vide les champs et on ferme la fenêtre
        nomSaisi = ""
        caloriesSaisies = ""
        proteinesSaisies = ""
        montrantAjout = false
    }
    
    private func supprimerAliment(offsets: IndexSet) {
        for index in offsets {
            context.delete(aliments[index])
        }
    }
}
