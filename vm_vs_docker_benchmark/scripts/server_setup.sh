#!/bin/bash

# --- CONFIGURACIÓN ---
DURATION_MINUTES=30
END_TIME=$(( $(date +%s) + DURATION_MINUTES * 60 ))
VM_SCRIPT="./vm_setup.sh"
DOCKER_SCRIPT="./docker_setup.sh"

# --- FUNCIÓN: lanzar scripts en paralelo ---
start_servers() {
  echo "🚀 Lanzando servidores Minecraft en paralelo (VM + Docker)..."
  bash "$VM_SCRIPT" &
  PID_VM=$!
  bash "$DOCKER_SCRIPT" &
  PID_DOCKER=$!
}

# --- FUNCIÓN: control de duración ---
wait_duration() {
  echo "⏳ Esperando $DURATION_MINUTES minutos con ambos servidores en ejecución..."
  while [ "$(date +%s)" -lt "$END_TIME" ]; do
    sleep 10
  done
}

# --- FUNCIÓN: esperar finalización ---
wait_for_completion() {
  echo "🛑 Tiempo completado. Esperando a que los scripts terminen..."
  wait $PID_VM
  wait $PID_DOCKER
}

# --- EJECUCIÓN ---
start_servers
wait_duration
wait_for_completion

echo "✅ Ambos entornos detenidos y métricas recopiladas."
echo "📁 Revisa los archivos 'vm_metrics.txt' y 'docker_minecraft_metrics.txt'."
