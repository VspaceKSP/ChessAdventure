# Chess Adventure

Chess Adventure est un projet de jeu d'échecs développé avec Flutter et Dart.

L'objectif est de construire progressivement un jeu d'échecs orienté autour de quêtes, de défis et de conditions spéciales, plutôt qu'une simple application de parties classiques.

Le projet est actuellement en phase de prototype / développement du cœur du jeu.

---

## État actuel du projet

Le prototype possède maintenant un véritable échiquier fonctionnel utilisant une librairie de règles d'échecs.

### Fonctionnalités actuellement implémentées

- Échiquier 8x8 responsive
- Affichage des coordonnées `a-h` et `1-8`
- Pièces d'échecs en SVG
- Sélection des pièces au toucher
- Mise en évidence de la pièce sélectionnée
- Déplacements légaux des pièces
- Captures
- Alternance automatique Blancs / Noirs
- Gestion des pièces bloquées
- Gestion de l'échec
- Impossibilité de jouer un coup laissant le roi en échec
- Roque
- Promotion de pion
  - actuellement automatique en Dame
- Support des règles standards via la librairie Dart `chess`

---

## Architecture actuelle

Le projet commence à être séparé en plusieurs responsabilités.

```text
lib/
├── main.dart
│
├── game/
│   ├── chess_game.dart
│   └── chess_rules.dart
│
└── ui/
    └── chess_board.dart