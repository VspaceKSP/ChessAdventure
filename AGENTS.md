# Instructions de développement de Chess Adventure

## Consentement

- Ne modifier, créer, déplacer ou supprimer aucun fichier sans le consentement explicite de l’utilisateur.
- Avant toute modification, expliquer clairement ce qui sera changé, dans quels fichiers et pourquoi.
- Une autorisation concerne uniquement les changements présentés. Demander un nouveau consentement si la portée change.
- La lecture des fichiers et l’analyse du projet sont permises sans autorisation.
- Ne pas créer de commit Git et ne rien pousser sur GitHub sans consentement explicite.

## Méthode de travail

- Construire le jeu progressivement, une petite brique à la fois.
- Garder le projet fonctionnel entre les étapes.
- Éviter les grosses refactorisations, sauf si elles ont été discutées et approuvées.
- Ne pas ajouter une fonctionnalité simplement parce qu’elle pourrait être utile plus tard.
- Respecter le document de vision et garder le MVP volontairement petit.
- Après une modification, vérifier le code avec les outils Flutter appropriés.
- Les essais visuels et tactiles importants seront confirmés par l’utilisateur sur son téléphone.

## Apprentissage de Dart et Flutter

- L’utilisateur apprend Dart et Flutter pendant le développement du jeu.
- Lorsqu’un nouveau concept est introduit, expliquer simplement ce qu’il fait et pourquoi il est nécessaire.
- Présenter les changements en petites sections compréhensibles.
- Éviter de fournir un gros bloc de code sans explication.
- Relier les explications au fonctionnement concret de Chess Adventure.
- Lorsque possible, laisser l’utilisateur écrire ou compléter les petites modifications avec des indices progressifs.
- Expliquer le chemin d’une action dans Flutter : événement, fonction appelée, changement d’état et reconstruction de l’interface.

## Architecture

- Garder la logique du jeu indépendante de l’interface Flutter autant que possible.
- Flutter affiche le jeu; le cœur du jeu décide ce qui se passe.
- Respecter les responsabilités existantes :
  - `ChessGame` gère l’état et les règles de la partie.
  - `ChessBoard` affiche l’échiquier et traite les interactions sur les cases.
  - `GameScreen` rassemble la partie, l’échiquier et les commandes de l’écran.
- Expliquer et faire approuver toute nouvelle couche d’architecture avant de l’ajouter.

## Fin d’une étape

À la fin de chaque petite étape :

1. Expliquer ce qui a changé.
2. Indiquer les fichiers touchés.
3. Expliquer les nouveaux concepts Dart ou Flutter.
4. Donner le résultat de l’analyse ou des tests.
5. Signaler ce que l’utilisateur doit vérifier sur son téléphone.
6. Proposer une seule prochaine étape claire.
7. Attendre une autorisation avant de créer un commit Git.
