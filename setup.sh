#!//bin/bash -eu

# メニュー
option1[0]="OpenSSH"
option1[1]="Nvidia-Driver"
option1[2]="CUDA"

# CUDAバージョン
option2[0]="10.1"
option2[1]="10.2"
option2[2]="11.0"

function SETUP {
  sudo apt -y update
  sudo apt -y upgrade
  sudo apt -y autoremove
  sudo apt -y clean
}

# OpenSSH
function OPENSSH {
  sudo apt -y install openssh-server
  sudo sed -i "s/LoginGraceTime 120/LoginGraceTime 30/" /etc/ssh/sshd_config
  sudo sed -i "s/IgnoreRhosts no/IgnoreRhosts yes/" /etc/ssh/sshd_config
  sudo sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin no/" /etc/ssh/sshd_config
  sudo sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/" /etc/ssh/sshd_config
}

# Nvidia-Driver
function NDRIVER {
  sudo apt -y remove nvidia-*
  sudo apt -y remove cuda-*
  sudo apt -y autoremove
  sudo add-apt-repository -y ppa:graphics-drivers/ppa
  sudo apt -y update
  sudo ubuntu-drivers autoinstall
}

# CUDA
function CUDA {
  if [ $# -gt 0 ] ; then
    sudo apt -y remove nvidia-*
    sudo apt -y remove cuda-*
    sudo apt -y autoremove
    sudo add-apt-repository -y ppa:graphics-drivers/ppa
    sudo apt -y update
    sudo ubuntu-drivers autoinstall
    # sudo apt -y install nvidia-driver-415
    # CUDA 10.1 & cuDNN 8.0.2 & Ubuntu 18.04
    if [ "$1" == "10.1" ]; then
      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
      sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
      wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-ubuntu1804-10-1-local-10.1.243-418.87.00_1.0-1_amd64.deb
      sudo apt-key add /var/cuda-repo-10-1-local-10.1.243-418.87.00/7fa2af80.pub
      sudo dpkg -i cuda-repo-ubuntu1804-10-1-local-10.1.243-418.87.00_1.0-1_amd64.deb
      sudo apt-get update
      sudo apt-get -y install cuda
      rm cuda-repo-ubuntu1804-10-1-local-10.1.243-418.87.00_1.0-1_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8_8.0.2.39-1+cuda10.1_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8-dev_8.0.2.39-1+cuda10.1_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8-doc_8.0.2.39-1+cuda10.1_amd64.deb
    # CUDA 10.2 & cuDNN 8.0.2 & Ubuntu 18.04
    elif [ "$1" == "10.2" ]; then
      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
      sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
      wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
      sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
      sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
      sudo apt-get update
      sudo apt-get -y install cuda
      rm cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8_8.0.2.39-1+cuda10.2_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8-dev_8.0.2.39-1+cuda10.2_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8-doc_8.0.2.39-1+cuda10.2_amd64.deb
      # CUDA 11.0 & cuDNN 8.0.2 & Ubuntu 18.04
    elif [ "$1" == "11.0" ]; then
      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
      sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
      wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_amd64.deb
      sudo apt-key add /var/cuda-repo-ubuntu1804-11-0-local/7fa2af80.pub
      sudo dpkg -i cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_amd64.deb
      sudo apt-get update
      sudo apt-get -y install cuda
      rm cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8_8.0.2.39-1+cuda11.0_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8-dev_8.0.2.39-1+cuda11.0_amd64.deb
      sudo dpkg -i cuDNN8.0.2/libcudnn8-doc_8.0.2.39-1+cuda11.0_amd64.deb
    fi
  fi
}

function COMMAND () {
  for n in ${!option1[@]} ; do
    if [[ ${choices1[$n]} ]]; then
      case "$n" in
        "0" ) OPENSSH       ;;
        "1" ) NDRIVER       ;;
        "2" ) MAIN_SELECT 2 ;;
      esac
    fi
  done
  for n in ${!option2[@]} ; do
    if [[ ${choices2[$n]} ]]; then
      case "$n" in
        "0" ) CUDA ${option2[$n]} ;;
        "1" ) CUDA ${option2[$n]} ;;
        "2" ) CUDA ${option2[$n]} ;;
      esac
    fi
  done
}

function MAIN_SELECT {
  current_line=0
  case "$1" in
    "1"  ) OPTION=("${option1[@]}")  ;;
    "2"  ) OPTION=("${option2[@]}")  ;;
  esac
  while clear && MAIN_MENU $1 && IFS= read -r -n1 -s SELECTION && [[ -n "$SELECTION" ]]; do
    [[ $SELECTION == $'\x1b' ]] && read -r -n2 -s rest && SELECTION+="$rest"
    clear ; case $SELECTION in
    $'\x1b\x5b\x41' ) [[ $current_line -ne 0 ]]                      && current_line=$(( current_line - 1 )) || current_line=$(( ${#OPTION[@]}-1 )) ;;
    $'\x1b\x5b\x42' ) [[ $current_line -ne $(( ${#OPTION[@]}-1 )) ]] && current_line=$(( current_line + 1 )) || current_line=0                      ;;
    $'\x20'         )
    case $1 in
      "1"  ) [[ "${choices1[current_line]}" == "+"  ]] && choices1[current_line]=""  || choices1[current_line]="+"  ;;
      "2"  ) [[ "${choices2[current_line]}" == "+"  ]] && choices2[current_line]=""  || choices2[current_line]="+"  ;;
    esac
  esac
done
}

function MAIN_MENU {
  case "$1" in
    "1"  ) echo -e "Which do you install ?\n" ;;
    "2"  ) echo -e "Which do you select ?\n" ;;
  esac
  echo "移動:[↑]or[↓], 選択:[SPACE], 決定:[ENTER]"
  for n in ${!OPTION[@]}; do
    [ $n -eq $current_line ] && echo -n ">" || echo -n " "
    case "$1" in
      "1"  ) echo -e "[${choices1[$n]:- }]: ${option1[$n]}"   ;;
      "2"  ) echo -e "[${choices2[$n]:- }]: ${option2[$n]}"   ;;
    esac
  done
}

SETUP ; MAIN_SELECT 1 ; COMMAND ; SETUP
