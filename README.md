# 下载脚本
cd / && git clone https://github.com/AprilOneDay/k8s.git && chmod -R 777 /k8s/install

# 安装k8s
/k8s/install/install-k8s.sh <name>

# 初始化master
/k8s/install/install-master.sh <name>

# 创建node
/k8s/install/install-node.sh <token> <mater_ip:port[6443]>