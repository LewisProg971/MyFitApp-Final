import SwiftUI
import SwiftData

struct CalendrierView: View {
    @Environment(\.modelContext) private var context
    @Query private var toutesLesJournees: [Journee]
    
    // 👉 On ajoute cette ligne pour avoir accès à tout ton carnet d'exercices
    @Query private var tousLesExercices: [ExerciceProgramme]
    
    @State private var dateSelectionnee = Date()
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
                .safeAreaPadding(.bottom, 150)
            }
            .navigationTitle("Mon Suivi")
            .toolbar {
                if let journee = journeeActuelle {
                    ToolbarItem(placement: .topBarTrailing) {
                        ShareLink(item: genererPDF(journee: journee)) {
                            Label("Exporter PDF", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .sheet(isPresented: $montrantAjoutRepas) {
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
    
    @MainActor
        func genererPDF(journee: Journee) -> URL {
            var perfsDuJour: [PerfPDF] = []
            for exo in tousLesExercices {
                for perf in exo.performances {
                    if Calendar.current.isDate(perf.date, inSameDayAs: journee.date) {
                        perfsDuJour.append(PerfPDF(nomExo: exo.nom, charge: perf.charge, sensation: perf.sensation))
                    }
                }
            }
            
            let renderer = ImageRenderer(content: RecapPDFView(journee: journee, performances: perfsDuJour))
            
            // 👉 LA CORRECTION EST ICI : On utilise "temporaryDirectory" pour autoriser le partage
            let url = URL.temporaryDirectory.appending(path: "Bilan_MyFitApp.pdf")
            
            renderer.render { size, context in
                var box = CGRect(origin: .zero, size: size)
                guard let pdfContext = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
                
                pdfContext.beginPDFPage(nil)
                context(pdfContext)
                pdfContext.endPDFPage()
                pdfContext.closePDF()
            }
            
            return url
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
