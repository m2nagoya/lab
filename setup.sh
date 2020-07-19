#!//bin/bash -eu

################################################
# Ubuntu 18.04
# GTX 2080Ti
# CUDA 11.0
# cuDNN 8.0.1
################################################

# ローカルに移動
cd $HOME

# 不要ファイルの削除
rm examples.desktop 2>/dev/null

# IPアドレス固定
echo -e "# interfaces(5) file used by ifup(8) and ifdown(8)\nauto enp3s0
auto enp3s0
iface enp3s0 inet static
    address 192.168.3.65
    netmask 255.255.255.0
    gateway 192.168.0.1
    dns-nameservers 192.168.0.1" > /etc/network/interfaces

# OpenSSH
sudo apt -y install openssh-server
sudo sed -i "s/LoginGraceTime 120/LoginGraceTime 30/" /etc/ssh/sshd_config
sudo sed -i "s/IgnoreRhosts no/IgnoreRhosts yes/" /etc/ssh/sshd_config
sudo sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin no/" /etc/ssh/sshd_config
sudo sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/" /etc/ssh/sshd_config

# Git
sudo apt -y install git

# Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-ppc64le.sh
bash https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-ppc64le.sh
rm https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-ppc64le.sh

# Pip(Python3)
sudo apt -y install python3-pip

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
sudo apt -y update
sudo apt-get install cuda-toolkit-11-0
rm cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_amd64.deb

# cuDNN
sudo dpkg -i cuDNN8.0.1/libcudnn8_8.0.1.13-1+cuda11.0_amd64.deb
sudo dpkg -i cuDNN8.0.1/libcudnn8-dev_8.0.1.13-1+cuda11.0_amd64.deb
sudo dpkg -i cuDNN8.0.1/libcudnn8-doc_8.0.1.13-1+cuda11.0_amd64.deb

# 不要ファイルの削除
sudo apt list --upgradable
sudo apt -y autoremove
sudo apt -y clean
