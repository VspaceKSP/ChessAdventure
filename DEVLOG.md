# Journal de développement de Chess Adventure

Ce journal permet de reprendre rapidement le développement après une pause. Il complète le document de vision, qui reste la référence pour les objectifs à long terme et les décisions de conception.

## Vision résumée

Chess Adventure est un jeu d’échecs centré sur des quêtes, des objectifs et des contraintes variées.

Le joueur doit pouvoir ouvrir le jeu, choisir rapidement un défi intéressant et jouer immédiatement, même s’il ne dispose que de quelques minutes.

Phrase boussole :

> Des échecs pour quand tu veux un défi, pas nécessairement une partie.

La priorité actuelle est de construire un petit prototype fonctionnel. Les grandes fonctionnalités comme le cloud, la boutique, le multijoueur et la génération procédurale viendront beaucoup plus tard.

## MVP visé

Le premier MVP doit contenir :

- une application Flutter fonctionnant sur Android;
- un échiquier standard;
- les règles d’échecs fonctionnelles;
- une seule quête jouable;
- trois objectifs;
- un résultat de une à trois étoiles;
- une façon rapide de recommencer;
- une sauvegarde locale minimale.

## État actuel

### Fonctionnel

- Projet Flutter créé et lancé sur un téléphone Android.
- Écran d’accueil avec un bouton pour commencer une partie.
- Échiquier responsive de 8 × 8 cases.
- Coordonnées `a-h` et `1-8`.
- Pièces classiques affichées avec des fichiers SVG.
- Sélection d’une pièce au toucher.
- Déplacement par toucher ou glisser-déposer.
- Pièce déplacée affichée au-dessus du doigt.
- Indicateur visuel de la case ciblée pendant le glisser-déposer.
- Affichage des destinations légales.
- Refus des coups illégaux.
- Refus de sélectionner les pièces de l’autre camp.
- Alternance automatique entre les Blancs et les Noirs.
- Captures.
- Détection des pièces bloquées.
- Gestion de l’échec et des coups laissant le roi en échec.
- Roque.
- Promotion manuelle avec choix entre dame, tour, fou et cavalier.
- Boîte de promotion visuelle composée de quatre cases SVG verticales.
- Pièces de promotion affichées dans la couleur du joueur.
- Écran assombri pendant la sélection de promotion.
- Fermeture de la boîte sans choix = coup annulé et pion remis sur sa case.
- Historique élémentaire des coups.
- Boutons Undo et Reset avec confirmation.
- Palette visuelle centralisée dans `ChessBoardPalette`.
- Coordonnées de l’échiquier liées aux couleurs de la palette.
- Surbrillance de la case de départ et de la case d’arrivée du dernier coup.
- Détection du roi en échec et de l’échec et mat.
- Case du roi en échec animée en rouge avec une animation arrêtée hors échec.
- Analyse Flutter à confirmer après les dernières modifications.

### Architecture actuelle

- `main.dart` démarre l’application.
- `HomeScreen` affiche l’accueil et ouvre une nouvelle partie.
- `GameScreen` possède la partie et rassemble l’échiquier, les commandes et l’historique.
- `ChessBoard` affiche les cases, les pièces et les interactions.
- `ChessGame` encapsule la bibliothèque `chess` et expose les opérations utiles à l’interface.
- `chess_rules.dart` contient d’anciennes règles écrites manuellement, mais n’est plus utilisé par l’application actuelle.

Cette séparation va dans le sens de la vision : Flutter affiche le jeu, tandis que le cœur du jeu décide ce qui se passe.

## Problèmes et limites connus

- Les flèches permettant de parcourir l’historique sont affichées, mais désactivées.
- Il n’existe pas encore de sélection du style des pièces.
- Aucune quête ni aucun objectif n’est encore implémenté.
- Il n’existe pas encore de test automatisé propre au projet.
- L’identifiant Android utilise encore la valeur temporaire `com.example.chess_quest`.

## Prochaine petite étape

Après la validation visuelle des dernières briques, choisir une seule direction :

- ajouter l’orientation du plateau et le mode permettant de jouer les Noirs;
- améliorer la navigation dans l’historique;
- commencer une première quête très simple.

Le moteur adverse complet restera une étape beaucoup plus tardive, après la base de jeu et l’expérience joueur.

## Étapes envisagées ensuite

Une seule étape sera choisie à la fois.

- Ajouter le choix entre les pièces classiques et les symboles Unicode.
- Améliorer la navigation dans l’historique.
- Commencer une première quête très simple.
- Ajouter progressivement trois objectifs et le calcul des étoiles.
- Ajouter le choix entre les pièces classiques et les symboles Unicode dans un futur menu Options.

## Historique des points de sauvegarde Git

- Création de l’application Flutter Android.
- Ajout de l’échiquier interactif, des pièces et des coordonnées.
- Ajout des premières règles de déplacement.
- Intégration de la bibliothèque `chess`.
- Ajout des coups légaux, de l’état de la partie et de la promotion.
- Finalisation du glisser-déposer et nettoyage de la structure de l’échiquier.
- Ajout de la sélection visuelle de la pièce lors d’une promotion.
- Centralisation des couleurs du plateau dans une palette.
- Ajout des coordonnées liées à la palette, de la surbrillance du dernier coup et du signal visuel d’échec.

## Session du 5 septembre 2026

### Fait

- Reprise du contexte de développement.
- Lecture de la conversation « Monter lenvironnement Flutter ».
- Lecture du document de vision.
- Examen des fichiers Dart et de l’état Git.
- Vérification du projet avec l’analyse Flutter.
- Création d’un fichier `AGENTS.md` contenant les règles de collaboration et d’apprentissage.

### Problèmes

- La disposition de l’historique doit être corrigée.
- Aucun problème de code n’est actuellement signalé par l’analyse Flutter.

### Prochaine étape

Corriger uniquement la disposition de `GameScreen`, après présentation du changement et consentement explicite de l’utilisateur.

## Session du 6 septembre 2026

### Fait

- Correction de la disposition de `GameScreen` : échiquier, boutons de partie et historique sont maintenant séparés en rangées distinctes.
- Ajout de la détection des coups de promotion dans `ChessGame`.
- Remplacement de la promotion automatique en dame par un choix fourni par l’interface.
- Création d’un overlay de promotion vertical placé dans la colonne du pion.
- Affichage des quatre pièces avec les SVG classiques et la couleur du joueur.
- Assombrissement de l’écran pendant la promotion.
- Annulation correcte du coup lorsque l’overlay est fermé sans sélectionner de pièce.
- Test complet effectué sur le téléphone : la promotion est fonctionnelle.

### Problèmes

- Aucun problème fonctionnel connu pour la promotion.
- L’analyse Flutter complète doit encore être relancée depuis le terminal local.

### Prochaine étape

Choisir entre l’amélioration de la navigation dans l’historique et la création d’une première quête très simple.
## Session du 8 septembre 2026

### Fait

- Création de `ChessBoardPalette` pour regrouper les couleurs du plateau et des indications visuelles.
- Intégration de la palette classique dans `GameScreen`.
- Liaison des coordonnées `a-h` et `1-8` aux couleurs claire et foncée de la palette.
- Mémorisation des cases de départ et d’arrivée du dernier coup dans `ChessGame`.
- Ajout de la surbrillance transparente des deux cases du dernier coup.
- Ajout de la détection de l’échec et de l’échec et mat.
- Ajout du clignotement rouge sur la case du roi en échec.
- Ajustement du contrôleur pour qu’il s’anime seulement lorsqu’un échec est présent.

### Validation

- Le diff Git ne contient pas d’espace ou de conflit détecté.
- L’analyse Flutter doit être relancée après la dernière correction de code.
- Le test visuel doit confirmer les cases source/destination, l’échec clignotant, Undo et Reset.

### Prochaine étape

Valider le comportement sur le téléphone, puis choisir entre l’orientation du plateau avec le mode Noirs, l’historique ou la première quête.