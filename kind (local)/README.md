# 로컬 환경에서 쿠버네티스 사용 사례 (Kind)

```sh
# 브랜드 정보
sysctl -a |grep -i brand

machdep.cpu.brand_string: Apple M3 Pro

# CPU 아키텍처 정보
arch
arm64
```

## Docker Desktop 설치

실습 환경 : Kind 사용하는 도커 엔진 리소스에 최소 vCPU 4, Memory 8GB 할당을 권고

```sh
# Install Kind
brew install kind
kind --version

# Install kubectl
brew install kubernetes-cli
kubectl version --client=true

# Install Helm
brew install helm
helm version
```

```sh
# 클러스터 배포 전 확인
docker ps

# 환경변수 지정 : 각자 kubeconfig 편리한 위치 설정
export KUBECONFIG=Downloads/k8s/config

# '컨트롤플레인, 워커 노드 1대' 클러스터 배포 : 파드에 접속하기 위한 포트 맵핑 설정
cat <<EOT> kind-2node.yaml
# two node (one workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 31000
    hostPort: 31000
    listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
    protocol: tcp # Optional, defaults to tcp
  - containerPort: 31001
    hostPort: 31001
EOT

CLUSTERNAME=myk8s
kind create cluster --config kind-2node.yaml --name $CLUSTERNAME

# 배포 확인
kind get clusters
kind get nodes --name $CLUSTERNAME

kubectl get nodes -o wide
```

```sh
# kube-ops-view
# helm show values geek-cookbook/kube-ops-view
helm repo add geek-cookbook https://geek-cookbook.github.io/charts/
helm install kube-ops-view geek-cookbook/kube-ops-view --version 1.2.2 --set service.main.type=NodePort,service.main.ports.http.nodePort=31000 --set env.TZ="Asia/Seoul" --namespace kube-system

# 설치 확인
kubectl get deploy,pod,svc,ep -n kube-system -l app.kubernetes.io/instance=kube-ops-view

# kube-ops-view 접속 URL 확인 (1.5 , 2 배율)
echo -e "KUBE-OPS-VIEW URL = http://localhost:31000/#scale=1.5"

```

```sh
# 디플로이먼트와 서비스 배포
cat <<EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-websrv
spec:
  replicas: 2
  selector:
    matchLabels:
      app: deploy-websrv
  template:
    metadata:
      labels:
        app: deploy-websrv
    spec:
      terminationGracePeriodSeconds: 0
      containers:
      - name: deploy-websrv
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: deploy-websrv
spec:
  ports:
    - name: svc-webport
      port: 80
      targetPort: 80
      nodePort: 31001
  selector:
    app: deploy-websrv
  type: NodePort
EOF

# 확인
docker ps
CONTAINER ID   IMAGE                  COMMAND                   CREATED         STATUS         PORTS                                  NAMES
117a1145a676   kindest/node:v1.29.2   "/usr/local/bin/entr…"   7 minutes ago   Up 7 minutes   0.0.0.0:31000-31001->31000-31001/tcp   myk8s-worker
...

kubectl get deploy,svc,ep deploy-websrv
...
NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/deploy-websrv   NodePort   10.96.204.112   <none>        80:31001/TCP   55s
...

# 자신의 PC에 호스트 포트 31001 접속 시 쿠버네티스 서비스에 접속 확인
curl -s localhost:31001 | grep -o "<title>.*</title>"
<title>Welcome to nginx!</title>

# 디플로이먼트와 서비스 삭제
kubectl delete deploy,svc deploy-websrv
```
