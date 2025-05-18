# Stage 1: Build
FROM node:18 as builder
WORKDIR /app

# Copia solo los archivos necesarios para npm install
COPY package*.json ./
RUN npm install

# Copia el resto de archivos
COPY . .

# Stage 2: Runtime
FROM nginx:alpine
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]