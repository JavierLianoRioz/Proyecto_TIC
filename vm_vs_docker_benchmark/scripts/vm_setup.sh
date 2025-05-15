#!/bin/bash

# --- CONFIGURACIÓN ---
VM_NAME="MinecraftVM"
VM_RAM=2048          # En MB
VM_CPU=2
VM_DISK=10000        # En MB
ISO_PATH="$HOME/ISOs/ubuntu-22.04-live-server-amd64.iso"
VBOX_DIR="$HOME/VirtualBox VMs/$VM_NAME"
DURATION_MINUTES=30
END_TIME=$(( $(date +%s) + DURATION_MINUTES * 60 ))

# --- FUNCIÓN: crear VM ---
create_vm() {
  echo "🧱 Creando VM '$VM_NAME'..."
  VBoxManage createvm --name "$VM_NAME" --ostype Ubuntu_64 --register
}

# --- FUNCIÓN: configurar hardware ---
configure_hardware() {
  echo "🧠 Asignando CPU/RAM/Red..."
  VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --cpus "$VM_CPU" --nic1 nat
}

# --- FUNCIÓN: crear y asignar disco duro ---
create_disk() {
  echo "💽 Creando disco virtual..."
  VBoxManage createmedium disk --filename "$VBOX_DIR/$VM_NAME.vdi" --size "$VM_DISK"
  VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
  VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VBOX_DIR/$VM_NAME.vdi"
}

# --- FUNCIÓN: asociar ISO de Ubuntu ---
attach_iso() {
  echo "📀 Asociando ISO de Ubuntu Server..."
  VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
  VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"
}

# --- FUNCIÓN: habilitar SSH NAT port forwarding ---
enable_ssh_forwarding() {
  VBoxManage modifyvm "$VM_NAME" --natpf1 "guestssh,tcp,,2222,,22"
}

# --- FUNCIÓN: iniciar VM ---
start_vm() {
  echo "🚀 Iniciando VM '$VM_NAME'..."
  VBoxManage startvm "$VM_NAME"
}

# --- FUNCIÓN: recoger métricas simuladas ---
collect_metrics() {
  echo "📊 Recogiendo métricas de VM (simuladas)..."
  # Aquí se podría implementar la recogida real de métricas si se dispone de herramientas
  echo "CPU: N/A" > vm_metrics.txt
  echo "Memoria: N/A" >> vm_metrics.txt
  echo "📝 Métricas guardadas en 'vm_metrics.txt'."
}

# --- FUNCIÓN: control de duración ---
wait_duration() {
  echo "⏳ VM corriendo durante $DURATION_MINUTES minutos..."
  while [ "$(date +%s)" -lt "$END_TIME" ]; do
    sleep 10
  done
}

# --- EJECUCIÓN ---
create_vm
configure_hardware
create_disk
attach_iso
enable_ssh_forwarding
start_vm
wait_duration
collect_metrics

echo "🛠️ Instala Ubuntu manualmente ahora. Luego asegúrate de poder hacer SSH a 'localhost:2222'."
echo "Después podrás instalar el servidor de Minecraft con el script anterior."
