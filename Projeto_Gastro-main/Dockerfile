# Flutter Web Dockerfile
FROM ghcr.io/cirruslabs/flutter:3.29.3

WORKDIR /app

# Copiar arquivos de configuração primeiro
COPY pubspec.yaml pubspec.lock ./

# Instalar dependências
RUN flutter pub get

# Copiar o resto do código
COPY . .

# Build para web
RUN flutter build web --release

# Usar nginx para servir os arquivos estáticos
FROM nginx:alpine

# Copiar arquivos buildados do Flutter
COPY --from=0 /app/build/web /usr/share/nginx/html

# Configuração do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expor porta
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
