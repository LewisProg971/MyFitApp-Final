import SwiftUI
import SwiftData

struct CalendrierView: View {
    @Environment(\.modelContext) private var context
    @Query private var toutesLesJournees: [Journee]
    @State private var dateSelectionnee = Date()
    
    // 👉 Le déclencheur de la fenêtre est bien à la racine de l'écran
    @State private var montrantAjoutRepas = false
    
    var journeeActuelle: Journee? {
        toutesLesJournees.first { Calendar.current.isDate($0.date, inSameDayAs: dateSelectionnee) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    DatePicker("Sélectionne une date", selection: $dateSelectionnee, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor.secondarySystemBackground)))
                        .padding(.horizontal)
                    
                    if let journee = journeeActuelle {
                        SectionHydratation(journee: journee)
                        
                        // Quand on clique, on passe la variable à TRUE
                        SectionNutrition(journee: journee, actionOuvrirFenetre: {
                            montrantAjoutRepas = true
                        })
                    } else {
                        Button(action: creerJournee) {
                            Text("Démarrer cette journée")
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
                .padding(.top)
                // 👉 LA SOLUTION MAGIQUE POUR LE SCROLL :
                // On dit à la ScrollView de toujours garder 150 pixels de marge en bas,
                // ce qui repousse le contenu au-dessus de la barre de navigation.
                .safeAreaPadding(.bottom, 150)
            }
            .navigationTitle("Mon Suivi")
            // 👉 LA SOLUTION ANTI-FREEZE : La .sheet est attachée à la NavigationStack (le mur porteur).
            // Elle ne plantera plus jamais.
            .sheet(isPresented: $montrantAjoutRepas) {
                // On vérifie que la journée existe bien avant d'ouvrir la vue
                if let journee = journeeActuelle {
                    AjoutRepasView(journee: journee)
                }
            }
        }
    }
    
    private func creerJournee() {
        let nouvelleJournee = Journee(date: dateSelectionnee)
        context.insert(nouvelleJournee)
    }
}

// MARK: - Sous-vue pour l'Hydratation
struct SectionHydratation: View {
    @Bindable var journee: Journee
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.cyan)
                Text("Hydratation (\(String(format: "%.2f", journee.consommationEau)) L / 2.0 L)")
                    .font(.headline)
            }
            
            ProgressView(value: min(journee.consommationEau, 2.0), total: 2.0)
                .tint(journee.consommationEau >= 2.0 ? .green : .cyan)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.vertical, 5)
            
            HStack {
                Button("+ 0.25L (Verre)") { journee.consommationEau += 0.25 }
                Spacer()
                Button("+ 0.5L (Gourde)") { journee.consommationEau += 0.5 }
            }
            .buttonStyle(.bordered)
            .tint(.cyan)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor.secondarySystemBackground)))
        .padding(.horizontal)
    }
}

// MARK: - Sous-vue pour la Nutrition
struct SectionNutrition: View {
    @Bindable var journee: Journee
    var actionOuvrirFenetre: () -> Void
    
    var totalCalories: Int {
        journee.repas.reduce(0) { total, repas in
            total + repas.aliments.reduce(0) { $0 + $1.calories }
        }
    }
    
    var totalProteines: Double {
        journee.repas.reduce(0) { total, repas in
            total + repas.aliments.reduce(0) { $0 + $1.proteines }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "fork.knife")
                    .foregroundStyle(.orange)
                Text("Nutrition")
                    .font(.headline)
                Spacer()
                Text("\(totalCalories) kcal | \(totalProteines, specifier: "%.1f")g Prot")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.blue)
            }
            
            if journee.repas.isEmpty {
                Text("Aucun repas enregistré aujourd'hui.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(journee.repas) { repas in
                    VStack(alignment: .leading) {
                        Text(repas.nom).bold()
                        Text(repas.aliments.map { $0.nom }.joined(separator: ", "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
            
            Button(action: { actionOuvrirFenetre() }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter un repas")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.top, 5)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor.secondarySystemBackground)))
        .padding(.horizontal)
    }
}
