# JARVIS — Assistant IA (web)

Assistant vocal personnel : interface animée, voix du téléphone, cerveau Gemini,
et connexions aux applis de l'appareil (appels, SMS, WhatsApp, mail, Maps, agenda, météo).

C'est un site **statique** (un seul `index.html`) : il s'héberge partout, sans serveur.
Ta clé Gemini n'est **jamais** dans le code : tu la saisis dans les réglages, elle reste
dans le navigateur.

## Héberger sur GitHub Pages (gratuit, URL permanente)

Le dépôt est déjà prêt et un premier commit a été fait. Il te reste 3 étapes :

### 1. Créer un dépôt vide sur GitHub
- Va sur https://github.com/new
- Nom du dépôt : par ex. `jarvis`  → **Create repository**
  (laisse-le vide : ne coche ni README, ni .gitignore, ni licence)

### 2. Pousser le code (dans ce dossier `site/`)

Remplace `TON-UTILISATEUR` par ton identifiant GitHub :

```powershell
git remote add origin https://github.com/TON-UTILISATEUR/jarvis.git
git branch -M main
git push -u origin main
```

> Git te demandera de te connecter à GitHub la première fois (fenêtre de connexion).

### 3. Activer GitHub Pages
- Sur ton dépôt : **Settings** → **Pages**
- **Source** : *Deploy from a branch*
- **Branch** : `main` / `(root)` → **Save**
- Attends ~1 minute : ton site est en ligne à :

```
https://TON-UTILISATEUR.github.io/jarvis/
```

Ouvre cette adresse sur ton téléphone, va dans ⚙ Réglages, colle ta clé Gemini,
active les connexions voulues, et c'est parti. Astuce : menu du navigateur →
**« Ajouter à l'écran d'accueil »**.

## Mettre à jour le site plus tard

```powershell
git add .
git commit -m "Mise a jour"
git push
```

GitHub Pages se met à jour tout seul en ~1 minute.

## Autres hébergeurs (si un jour tu changes d'avis)
- **Netlify Drop** : glisse ce dossier sur https://app.netlify.com/drop
- **Cloudflare Pages / Vercel** : connecte ce dépôt GitHub, ils déploient automatiquement.
