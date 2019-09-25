# Deployment
kubectl apply -f /k8s/ingress-nginx/mandatory.yaml
kubectl apply -f /k8s/ingress-nginx/ingress-nginx-nodeport.yaml

# DaemonSet + HostNetwork + nodeSelector
kubectl label node <node-1> is-ingress=true
kubectl apply -f /k8s/ingress-nginx/mandatory-ds.yaml
