#!/bin/bash

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common dirmngr vim telnet curl nfs-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y docker.io kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo '{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "journald"
}' > /etc/docker/daemon.json
systemctl restart docker

mkdir -p ~/.kube
mkdir -p /home/vagrant/.kube

echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.$1'" > /etc/default/kubelet
kubeadm init --apiserver-advertise-address=172.27.11.10 --pod-network-cidr=10.244.0.0/16
cp /etc/kubernetes/admin.conf ~/.kube/config
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant: /home/vagrant/.kube
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/baremetal/deploy.yaml
kubectl patch deploy ingress-nginx-controller -n ingress-nginx --patch '{"spec" : {"template" : {"spec" : {"hostNetwork" : true}}}}'
kubectl annotate ingressclass nginx ingressclass.kubernetes.io/is-default-class=true

mkdir -p /srv/{jenkins,gitea,postgres}
mkdir -p /srv/{sonarqube_data,sonarqube_extensions,sonarqube_logs}
chown 1000:1000 /srv/*

sysctl -w vm.max_map_count=262144
echo 'vm.max_map_count=262144' > /etc/sysctl.d/elastic.conf
