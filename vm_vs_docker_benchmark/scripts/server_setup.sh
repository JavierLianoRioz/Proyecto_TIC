#!/bin/bash

# --- CONFIGURACIÓN GENERAL ---
DURATION_MINUTES=30
END_TIME=$(( $(date +%s) + DURATION_MINUTES * 60 ))

# --- RUTAS A LOS SCRIPTS ---
VM_SCRIPT="./vm_setup.sh"
DOCKER_SCRIPT="./docker_setup.sh"

# --- INICIAR VM Y DOCKER ---
echo "🚀 Lanzando servidores Minecraft en paralelo (VM + Docker)..."

# Lanzar el script de la VM en segundo plano
bash "$VM_SCRIPT" &
PID_VM=$!

# Lanzar el script de Docker en segundo plano
bash "$DOCKER_SCRIPT" &
PID_DOCKER=$!

# --- ESPERAR 30 MINUTOS ---
echo "⏳ Esperando $DURATION_MINUTES minutos con ambos servidores en ejecución..."
while [ "$(date +%s)" -lt "$END_TIME" ]; do
  sleep 10
done

# --- FINALIZAR ---
echo "🛑 Tiempo completado. Esperando a que los scripts terminen..."

wait $PID_VM
wait $PID_DOCKER

echo "✅ Ambos entornos detenidos y métricas recopiladas."
echo "📁 Revisa los archivos 'vm_metrics.txt' y 'docker_minecraft_metrics.txt'."
