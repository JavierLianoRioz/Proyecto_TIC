#!/bin/bash

# --- CONFIGURACIÓN ---
VM_NAME="MinecraftVM"
VM_RAM=2048          # En MB
VM_CPU=2
VM_DISK=10000        # En MB
ISO_PATH="$HOME/ISOs/ubuntu-22.04-live-server-amd64.iso"
VBOX_DIR="$HOME/VirtualBox VMs/$VM_NAME"

# --- CREAR VM ---
echo "🧱 Creando VM '$VM_NAME'..."
VBoxManage createvm --name "$VM_NAME" --ostype Ubuntu_64 --register

# --- CONFIGURAR HARDWARE ---
echo "🧠 Asignando CPU/RAM/Red..."
VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --cpus "$VM_CPU" --nic1 nat

# --- CREAR Y ASIGNAR DISCO DURO ---
echo "💽 Creando disco virtual..."
VBoxManage createmedium disk --filename "$VBOX_DIR/$VM_NAME.vdi" --size "$VM_DISK"
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VBOX_DIR/$VM_NAME.vdi"

# --- ASOCIAR ISO DE UBUNTU ---
echo "📀 Asociando ISO de Ubuntu Server..."
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"

# --- OPCIONAL: habilitar SSH NAT port forwarding ---
VBoxManage modifyvm "$VM_NAME" --natpf1 "guestssh,tcp,,2222,,22"

# --- ARRANCAR VM PARA INSTALAR UBUNTU ---
echo "🚀 Iniciando VM '$VM_NAME'..."
VBoxManage startvm "$VM_NAME"

echo "🛠️ Instala Ubuntu manualmente ahora. Luego asegúrate de poder hacer SSH a 'localhost:2222'."
echo "Después podrás instalar el servidor de Minecraft con el script anterior."

