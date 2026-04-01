# 🏋️‍♂️ MyFitApp

MyFitApp est une application iOS 100% native et personnelle, conçue pour centraliser le suivi d'entraînement (musculation/force), la nutrition et l'hydratation.

L'application a été pensée pour être totalement autonome, gratuite et respectueuse de la vie privée grâce à un stockage local des données.

## ✨ Fonctionnalités Principales (Les 4 Piliers)

L'application est divisée en 4 onglets interactifs :

* **📅 Tableau de Bord (Calendrier)** : Suivi quotidien des macros (Calories & Protéines) et jauge d'hydratation interactive avec un objectif journalier de 2L.
* **🏋️‍♂️ Entraînement (Sport)** : Gestion complète de programmes de musculation (ex: "Push/Pull/Legs"). Intégration d'un chronomètre de repos natif et d'un système de suivi (tracking) des charges soulevées et des sensations pour assurer la surcharge progressive.
* **🍎 Nutrition** : Création d'une bibliothèque d'aliments personnalisée et composition de repas qui viennent s'ajouter au bilan de la journée.
* **📺 Ressources** : Espace pour sauvegarder et ouvrir nativement des liens (Tutoriels YouTube, articles de motivation ou de santé).

## 🛠 Stack Technique

* **Plateforme :** iOS 16.0+
* **Interface :** SwiftUI
* **Base de données :** SwiftData (Stockage 100% local, aucun serveur requis)
* **Architecture :** MV (Model-View) simplifiée avec `@Query` et `@Environment(\.modelContext)`

## 🚀 Installation & Lancement
¬
1. Clonez ce dépôt sur votre Mac :
   ```bash
   git clone [https://github.com/LewisProg971/MyFitApp-Final.git](https://github.com/LewisProg971/MyFitApp-Final.git)

2. Ouvrez le fichier de projet ou le dossier dans Xcode.
              
3. Sélectionnez un simulateur (ex: iPhone 15 Pro) ou branchez votre iPhone physique.

4. Appuyez sur Cmd + R (ou le bouton Play) pour compiler et lancer l'application.

Note : Pour une installation sur un appareil physique avec un compte Apple gratuit, assurez-vous d'avoir configuré votre "Personal Team" dans l'onglet "Signing & Capabilities" et d'avoir activé le "Mode développeur" sur l'iPhone.
