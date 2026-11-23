# JARVIS — version PowerShell (ordinateur)

Un assistant JARVIS qui tourne directement dans le **terminal Windows**, en **PowerShell**,
**sans rien installer** (pas de Python). Il te parle avec la voix de Windows et réfléchit avec **Gemini**.

## Ce qu'il fait
- 💬 Tu tapes → 🧠 Gemini répond → 🔊 il te répond **à voix haute** (voix Windows)
- 🖥️ Commandes locales directes (sans IA) :
  - « ouvre chrome », « ouvre le bloc-notes », « ouvre spotify »…
  - « cherche les horaires de la poste »
  - « quelle heure est-il ? », « quel jour on est ? »

## Installation (30 secondes)
1. Télécharge ce dossier `powershell` depuis le dépôt
   (bouton **Code → Download ZIP**, puis ouvre le dossier `powershell`).
2. Récupère une **clé API Gemini** (gratuite) sur https://aistudio.google.com/api-keys → **Create API key**.

## Lancer
- **Le plus simple** : double-clic sur **`lancer-jarvis.bat`**.
- Ou dans un terminal, depuis ce dossier :

```powershell
powershell -ExecutionPolicy Bypass -File jarvis.ps1
```

Au **premier lancement**, il te demande ta clé API Gemini et l'enregistre dans
`jarvis.config.json` (gardée **en local**, jamais envoyée ailleurs).

Ensuite, tape ton message. Pour quitter : tape `quitter`.

## Notes
- Fonctionne sur **Windows 10/11** (PowerShell 5.1 inclus, ou PowerShell 7).
- La **voix** utilise les voix installées de Windows ; s'il y a une voix française, il la choisit.
- Ta clé reste sur ton PC. **Ne partage pas** `jarvis.config.json`.
- Besoin de la version **vocale complète** (micro, « Hey Jarvis », interface) ?
  → utilise la version web : https://developperdev8-design.github.io/Jarvis/
