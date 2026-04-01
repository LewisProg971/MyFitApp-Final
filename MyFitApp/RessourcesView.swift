import SwiftUI
import SwiftData

struct RessourcesView: View {
    @Query private var ressources: [Ressource]
    @Environment(\.modelContext) private var context
    
    @State private var montrantAjout = false
    @State private var titreSaisi = ""
    @State private var urlSaisie = ""
    @State private var categorieSaisie = "Tutoriel"
    let categories = ["Tutoriel", "Motivation", "Nutrition", "Autre"]
    
    var body: some View {
        NavigationStack {
            List {
                if ressources.isEmpty {
                    ContentUnavailableView(
                        "Aucune Ressource",
                        systemImage: "play.tv",
                        description: Text("Ajoute tes vidéos YouTube ou articles préférés ici.")
                    )
                } else {
                    ForEach(ressources) { ressource in
                        // Ce composant "Link" ouvre nativement Safari ou l'app YouTube !
                        if let lienURL = URL(string: ressource.url) {
                            Link(destination: lienURL) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(ressource.titre)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text(ressource.categorie)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundStyle(.blue)
                                            .clipShape(Capsule())
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                    .onDelete(perform: supprimerRessource)
                }
            }
            .navigationTitle("Mes Ressources")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { montrantAjout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $montrantAjout) {
                NavigationStack {
                    Form {
                        TextField("Titre de la vidéo", text: $titreSaisi)
                        TextField("Lien URL (ex: https://youtube.com/...)", text: $urlSaisie)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        
                        Picker("Catégorie", selection: $categorieSaisie) {
                            ForEach(categories, id: \.self) { cat in
                                Text(cat).tag(cat)
                            }
                        }
                    }
                    .navigationTitle("Nouvelle Ressource")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") { montrantAjout = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Sauvegarder") {
                                ajouterRessource()
                            }
                            .disabled(titreSaisi.isEmpty || urlSaisie.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    private func ajouterRessource() {
        // On s'assure que l'URL commence bien par http
        var lienPropre = urlSaisie
        if !lienPropre.lowercased().hasPrefix("http") {
            lienPropre = "https://" + lienPropre
        }
        
        let nouvelleRessource = Ressource(titre: titreSaisi, url: lienPropre, categorie: categorieSaisie)
        context.insert(nouvelleRessource)
        
        titreSaisi = ""
        urlSaisie = ""
        montrantAjout = false
    }
    
    private func supprimerRessource(offsets: IndexSet) {
        for index in offsets {
            context.delete(ressources[index])
        }
    }
}
