#!/bin/bash

# --- CONFIGURACIÓN ---
CONTAINER_NAME="minecraft_docker_test"
PORT=25565
MEMORY="2G"
DURATION_MINUTES=30
END_TIME=$(( $(date +%s) + DURATION_MINUTES*60 ))

# --- FUNCIÓN: verificar Docker ---
check_docker() {
  if ! command -v docker &> /dev/null; then
    echo "🐳 Docker no está instalado. Instalándolo..."
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker "$USER"
    echo "✅ Docker instalado. Reinicia sesión para aplicar permisos."
    exit 1
  else
    echo "✅ Docker está instalado."
  fi
}

# --- FUNCIÓN: iniciar contenedor ---
start_container() {
  echo "🚀 Iniciando servidor de Minecraft en Docker..."
  docker run -d \
    --name "$CONTAINER_NAME" \
    -e EULA=TRUE \
    -e MEMORY="$MEMORY" \
    -p $PORT:25565 \
    -v minecraft_data:/data \
    itzg/minecraft-server

  echo "🕹️ Servidor escuchando en el puerto $PORT..."
}

# --- FUNCIÓN: detener contenedor ---
stop_container() {
  echo "🛑 Deteniendo servidor Docker..."
  docker stop "$CONTAINER_NAME"
  docker rm "$CONTAINER_NAME"
}

# --- FUNCIÓN: métricas ---
collect_metrics() {
  echo "📊 Recogiendo métricas de Docker..."
  docker stats "$CONTAINER_NAME" --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" > docker_minecraft_metrics.txt
  echo "📝 Métricas guardadas en 'docker_minecraft_metrics.txt'."
}

# --- EJECUCIÓN ---
check_docker
start_container

echo "⏳ Servidor corriendo durante $DURATION_MINUTES minutos..."
while [ "$(date +%s)" -lt "$END_TIME" ]; do
  sleep 10
done

collect_metrics
stop_container

echo "✅ Prueba completada. ¡Puedes revisar las métricas!"
