import SwiftUI

struct PerfPDF: Identifiable {
    let id = UUID()
    let nomExo: String
    let charge: Double
    let sensation: Int
}

struct RecapPDFView: View {
    var journee: Journee
    var performances: [PerfPDF]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // --- EN-TÊTE ---
            HStack {
                VStack(alignment: .leading) {
                    Text("Bilan MyFitApp")
                        .font(.system(size: 30, weight: .bold))
                    Text(journee.date.formatted(date: .long, time: .omitted))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 40))
                    .foregroundStyle(.blue)
            }
            
            Divider()
            
            // --- SECTION 1 : LE SPORT ---
            // 👉 CORRECTION : On utilise une vraie icône d'haltère
            HStack {
                Image(systemName: "dumbbell.fill")
                Text("ENTRAÎNEMENT DU JOUR")
            }
            .font(.headline)
            .foregroundStyle(.blue)
            
            if performances.isEmpty {
                Text("Aucun exercice enregistré aujourd'hui.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                VStack(spacing: 10) {
                    ForEach(performances) { perf in
                        HStack {
                            Text(perf.nomExo)
                                .bold()
                            Spacer()
                            Text("\(perf.charge, specifier: "%.1f") kg")
                                .bold()
                            Text("(Sens. \(perf.sensation)/10)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            
            Divider()
            
            // --- SECTION 2 : LA NUTRITION ---
            // 👉 CORRECTION : On utilise de vrais couverts
            HStack {
                Image(systemName: "fork.knife")
                Text("BILAN NUTRITIONNEL")
            }
            .font(.headline)
            .foregroundStyle(.orange)
            
            HStack {
                Label("\(journee.consommationEau, specifier: "%.2f")L d'eau", systemImage: "drop.fill")
                    .foregroundStyle(.cyan)
                Spacer()
                Text("\(totalProteines, specifier: "%.1f")g de Protéines").bold()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            if !journee.repas.isEmpty {
                ForEach(journee.repas) { repas in
                    HStack {
                        Text(repas.nom).bold()
                        Spacer()
                        Text(repas.aliments.map { $0.nom }.joined(separator: ", "))
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
            
            // --- PIED DE PAGE ---
            Text("Généré par MyFitApp - Surcharge progressive en cours !")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(40)
        .frame(width: 595, height: 842)
        .background(.white)
    }
    
    var totalProteines: Double {
        journee.repas.reduce(0) { total, repas in
            total + repas.aliments.reduce(0) { $0 + $1.proteines }
        }
    }
}
