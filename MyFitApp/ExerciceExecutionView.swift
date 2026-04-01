import SwiftUI
import SwiftData
import Combine

struct ExerciceExecutionView: View {
    @Bindable var exercice: ExerciceProgramme
    @Environment(\.modelContext) private var context
    
    // États pour le chronomètre
    @State private var tempsRestant: Int
    @State private var timerActif = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // États pour le formulaire de performance
    @State private var chargeSaisie: Double = 0.0
    @State private var sensationSaisie: Double = 5.0 // Slider de 1 à 10
    
    init(exercice: ExerciceProgramme) {
        self.exercice = exercice
        // On initialise le chronomètre avec le temps prévu pour cet exercice
        _tempsRestant = State(initialValue: exercice.reposEnSecondes)
    }
    
    var body: some View {
        Form {
            // Section 1 : Rappel des consignes
            Section("Objectif") {
                HStack {
                    Text("Séries : \(exercice.series)")
                    Spacer()
                    Text("Reps : \(exercice.reps)")
                }
                .font(.headline)
                
                if !exercice.note.isEmpty {
                    Text(exercice.note)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Section 2 : Le Chronomètre
            Section("Repos (\(exercice.reposEnSecondes)s)") {
                VStack {
                    Text("\(tempsRestant) s")
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                        .foregroundStyle(tempsRestant == 0 ? .green : .primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            if tempsRestant == 0 { tempsRestant = exercice.reposEnSecondes }
                            timerActif.toggle()
                        }) {
                            Text(timerActif ? "Pause" : "Démarrer")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(timerActif ? .orange : .blue)
                        
                        Button("Reset") {
                            timerActif = false
                            tempsRestant = exercice.reposEnSecondes
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
            }
            
            // Section 3 : Suivi de progression (Tracking)
            Section("Valider ma performance d'aujourd'hui") {
                HStack {
                    Text("Charge (kg)")
                    Spacer()
                    TextField("Ex: 80", value: $chargeSaisie, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                
                VStack(alignment: .leading) {
                    Text("Sensation : \(Int(sensationSaisie))/10")
                    Slider(value: $sensationSaisie, in: 1...10, step: 1)
                }
                
                Button(action: enregistrerPerformance) {
                    Text("Enregistrer")
                        .frame(maxWidth: .infinity)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .padding(.vertical, 5)
            }
            
            // Section 4 : L'Historique
            if !exercice.performances.isEmpty {
                Section("Historique des charges") {
                    // On trie pour avoir la date la plus récente en haut
                    ForEach(exercice.performances.sorted(by: { $0.date > $1.date })) { perf in
                        HStack {
                            Text(perf.date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(perf.charge, specifier: "%.1f") kg")
                                .bold()
                            Text("(Sens. \(perf.sensation)/10)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: supprimerPerformance)
                }
            }
        }
        .navigationTitle(exercice.nom)
        .navigationBarTitleDisplayMode(.inline)
        // C'est ici que le chronomètre défile chaque seconde
        .onReceive(timer) { _ in
            if timerActif && tempsRestant > 0 {
                tempsRestant -= 1
            } else if tempsRestant == 0 {
                timerActif = false
            }
        }
    }
    
    // MARK: - Fonctions
    
    private func enregistrerPerformance() {
        let nouvellePerf = Performance(
            date: Date(), // Date du jour
            charge: chargeSaisie,
            sensation: Int(sensationSaisie)
        )
        // On relie cette performance à cet exercice précis
        exercice.performances.append(nouvellePerf)
    }
    
    private func supprimerPerformance(offsets: IndexSet) {
        let perfsTriees = exercice.performances.sorted(by: { $0.date > $1.date })
        for index in offsets {
            let perfASupprimer = perfsTriees[index]
            context.delete(perfASupprimer)
        }
    }
}
