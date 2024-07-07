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
