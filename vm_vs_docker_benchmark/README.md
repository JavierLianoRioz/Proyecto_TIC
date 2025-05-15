# VM vs Docker Performance Benchmark Project

This project compares resource usage and performance metrics between a full virtual machine (VirtualBox) and a Docker container.

## 🔧 Project Structure
- `notebooks/`: Jupyter Notebook for running and plotting benchmarks
- `scripts/`: Setup scripts for VM, Docker, and Dockerfile itself
- `results/`: Placeholder for benchmark results

## 📦 Requirements
- Python 3.8+
- Docker (host or WSL2)
- VirtualBox (with a Linux guest)
- `sysbench`, `jupyter`, `matplotlib`, `psutil`

## 🚀 Quick Start
```bash
# On VM or Docker:
cd scripts
bash vm_setup.sh      # For VirtualBox
bash docker_setup.sh  # For Docker or WSLshell2

https://docs.google.com/document/d/1HvflWXzk4PH2iXaoFdgowJF6W70bgEN6Yuq8bFuIY-8/edit?tab=t.s35eh3c9kd4a#heading=h.5brhynyetl90