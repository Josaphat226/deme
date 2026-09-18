# Image de base Node.js légère
FROM node:18-alpine

# Répertoire de travail
WORKDIR /app

# Copier les dépendances et les installer
COPY package*.json ./
RUN npm install --only=production

# Copier le reste du code
COPY . .

# Exposer le port
EXPOSE 3000

# Commande de démarrage
CMD ["node", "src/server.js"]