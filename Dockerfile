

# -------------------------------
# STAGE 1: Build
# -------------------------------
# 1. Utiliser une image de base Node.js légère
FROM node:12.7-alpine AS build

# 2. Définir le répertoire de travail
WORKDIR /usr/src/app

# 3. Copier les fichiers package.json et package-lock.json pour installer les dépendances
COPY package.json package-lock.json ./

# 4. Installer les dépendances
RUN npm install

# 5. Copier tout le contenu du projet dans le conteneur
COPY . .

# 6. Compiler le projet Angular pour la production
RUN npm run build

# -------------------------------
# STAGE 2: Run
# -------------------------------
# 1. Utiliser une image de base NGINX légère
FROM nginx:1.17.1-alpine

# 2. Copier le fichier de configuration personnalisé de NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# 3. Copier les fichiers de sortie Angular (build) dans le répertoire de déploiement NGINX
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html

# 4. Exposer le port 80 pour permettre l'accès au serveur
EXPOSE 80

# 5. Commande par défaut pour démarrer NGINX
CMD ["nginx", "-g", "daemon off;"]
