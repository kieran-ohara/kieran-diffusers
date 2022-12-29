# CUDA
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
sudo yum clean expire-cache
sudo yum -y install nvidia-driver-latest-dkms
sudo yum -y install cuda-11.7.1-1
sudo yum -y install cuda-drivers
