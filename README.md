# proxy-sbh-nginx

### 1. build project -> create jar -> create service image
ここでは、以下を行います。
- ビルド用のコンテナimageの生成
- jarファイル生成
- 生成したjarを使ったサービスのコンテナimageの生成
- nginx-proxy、MySQL、前述の各サービスimageのコンテナを起動するdocker-compose.yamlの生成
```
sh build.sh
```

### 2. start nginx-proxy -> start mysql ->  start microservices
```
docker-compose up
```

