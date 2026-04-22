#!/bin/bash

echo ".........----------------#################._.-.-INSTALL-.-._.#################----------------........."
# ... [Keep your existing bashrc/PS1 logic here] ...

# Don't ask to restart services
[ -f /etc/needrestart/needrestart.conf ] && sed -i 's/#\$nrconf{restart} = \x27i\x27/$nrconf{restart} = \x27a\x27/' /etc/needrestart/needrestart.conf

apt-get update
apt-get install -y docker.io vim build-essential jq python3-pip kubelet kubectl kubernetes-cni kubeadm containerd
pip3 install jc

echo ".........----------------#################._.-.-KUBERNETES-.-._.#################----------------........."
kubeadm reset -f
# ... [Keep your existing containerd config logic] ...

kubeadm init --pod-network-cidr '10.244.0.0/16' --service-cidr '10.96.0.0/16' --skip-token-print

# FIXED: Ensure the current user can actually run kubectl
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# Apply networking
kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"
# ... [Keep your existing untaint logic] ...

echo ".........----------------#################._.-.-Java and MAVEN-.-._.#################----------------........."
# FIXED: Jenkins in 2026 requires Java 17 or 21
apt install openjdk-21-jdk maven -y 
java -version

echo ".........----------------#################._.-.-JENKINS-.-._.#################----------------........."
# FIXED: Updated to the 2026 GPG Key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | gpg --dearmor -o /usr/share/keyrings/jenkins.gpg 
echo 'deb [signed-by=/usr/share/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/' > /etc/apt/sources.list.d/jenkins.list

apt update
apt install -y jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Add permissions
usermod -a -G docker jenkins
echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo ".........----------------#################._.-.-COMPLETED-.-._.#################----------------........."
root@devsecops-cloud:/home/ariel.m23/devsecops/setup/vm-install-script$ cat install-script-fix.sh 
#!/bin/bash

echo ".........----------------#################._.-.-INSTALL-.-._.#################----------------........."
# ... [Keep your existing bashrc/PS1 logic here] ...

# Don't ask to restart services
[ -f /etc/needrestart/needrestart.conf ] && sed -i 's/#\$nrconf{restart} = \x27i\x27/$nrconf{restart} = \x27a\x27/' /etc/needrestart/needrestart.conf

apt-get update
apt-get install -y docker.io vim build-essential jq python3-pip kubelet kubectl kubernetes-cni kubeadm containerd
pip3 install jc

echo ".........----------------#################._.-.-KUBERNETES-.-._.#################----------------........."
kubeadm reset -f
# ... [Keep your existing containerd config logic] ...

kubeadm init --pod-network-cidr '10.244.0.0/16' --service-cidr '10.96.0.0/16' --skip-token-print

# FIXED: Ensure the current user can actually run kubectl
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# Apply networking
kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"
# ... [Keep your existing untaint logic] ...

echo ".........----------------#################._.-.-Java and MAVEN-.-._.#################----------------........."
# FIXED: Jenkins in 2026 requires Java 17 or 21
apt install openjdk-21-jdk maven -y 
java -version

echo ".........----------------#################._.-.-JENKINS-.-._.#################----------------........."
# FIXED: Updated to the 2026 GPG Key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | gpg --dearmor -o /usr/share/keyrings/jenkins.gpg 
echo 'deb [signed-by=/usr/share/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/' > /etc/apt/sources.list.d/jenkins.list

apt update
apt install -y jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Add permissions
usermod -a -G docker jenkins
echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo ".........----------------#################._.-.-COMPLETED-.-._.#################----------------........."
