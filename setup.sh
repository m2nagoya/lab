#!//bin/bash -eu

################################################
# Ubuntu 18.04
# GTX 2080Ti
# CUDA 11.0
# cuDNN 8.0.1
################################################

# ローカルに移動
cd $HOME

# Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-ppc64le.sh
bash https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-ppc64le.sh
rm https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-ppc64le.sh

# 古いドライバーの削除
sudo apt -y remove nvidia-*
sudo apt -y remove cuda-*
sudo apt -y autoremove

# NVIDIA Driver
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt -y update
sudo ubuntu-drivers autoinstall
sudo apt -y install nvidia-cuda-toolkit

# CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu1804-11-0-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
rm cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_amd64.deb

# cuDNN
sudo dpkg -i cuDNN8.0.1/libcudnn8_8.0.1.13-1+cuda11.0_amd64.deb
sudo dpkg -i cuDNN8.0.1/libcudnn8-dev_8.0.1.13-1+cuda11.0_amd64.deb
sudo dpkg -i cuDNN8.0.1/libcudnn8-doc_8.0.1.13-1+cuda11.0_amd64.deb

# 不要ファイルの削除
sudo apt list --upgradable
sudo apt -y autoremove
sudo apt -y clean
