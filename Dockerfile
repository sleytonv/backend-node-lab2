# ---------- Base (solo package*.json para cache)
FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./

# ---------- Deps
FROM base AS deps
RUN npm ci

# ---------- Test
FROM deps AS test
COPY . .
RUN npm run test --if-present

# ---------- Build (si aplica)
FROM deps AS build
COPY . .
RUN npm run build --if-present

# ---------- Runtime liviano
FROM node:20-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app

# Solo dependencias de prod
COPY package*.json ./
RUN npm ci --omit=dev

# Artefactos (si tu app genera 'dist')
COPY --from=build /app/dist ./dist
# Si tu start ejecuta desde src y requiere otros archivos, copia lo necesario:
# COPY . .

# Buenas prácticas
USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]

