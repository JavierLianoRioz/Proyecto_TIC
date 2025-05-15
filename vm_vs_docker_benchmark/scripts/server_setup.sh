#!/bin/bash

# --- CONFIGURACIÓN ---
VM_USER="usuario"
VM_HOST="192.168.1.100"
VM_MINECRAFT_PATH="/home/usuario/minecraft_server"
LOCAL_DOCKER_NAME="minecraft_docker_test"
DURATION_MINUTES=30
END_TIME=$(date -d "+$DURATION_MINUTES minutes" +%s)

# --- FUNCIONES ---
start_vm_server() {
  echo "🖥️ Iniciando servidor en VM..."
  ssh "$VM_USER@$VM_HOST" "cd $VM_MINECRAFT_PATH && nohup java -Xms1G -Xmx2G -jar server.jar nogui > vm_output.log 2>&1 & echo \$! > vm_pid.txt"
}

stop_vm_server() {
  echo "🛑 Deteniendo servidor en VM..."
  ssh "$VM_USER@$VM_HOST" "kill \$(cat $VM_MINECRAFT_PATH/vm_pid.txt)"
}

start_docker_server() {
  echo "🐳 Iniciando servidor en Docker..."
  docker run -d --name "$LOCAL_DOCKER_NAME" -e EULA=TRUE -p 25566:25565 itzg/minecraft-server
}

stop_docker_server() {
  echo "🛑 Deteniendo servidor en Docker..."
  docker stop "$LOCAL_DOCKER_NAME" && docker rm "$LOCAL_DOCKER_NAME"
}

collect_metrics() {
  echo "📊 Recopilando métricas..."

  # VM Metrics
  ssh "$VM_USER@$VM_HOST" "ps -C java -o %cpu,%mem,etime" > vm_metrics.txt

  # Docker Metrics
  docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" > docker_metrics.txt

  echo "📄 Métricas guardadas en 'vm_metrics.txt' y 'docker_metrics.txt'."
}

# --- EJECUCIÓN ---

echo "🚀 Comenzando test de comparación entre VM y Docker..."
start_vm_server
start_docker_server

echo "🕒 Esperando $DURATION_MINUTES minutos..."
while [ "$(date +%s)" -lt "$END_TIME" ]; do
  sleep 10
done

echo "✅ Tiempo completado. Deteniendo servidores..."
stop_vm_server
stop_docker_server

collect_metrics

echo "🏁 Prueba finalizada. ¡Métricas listas para analizar!"
