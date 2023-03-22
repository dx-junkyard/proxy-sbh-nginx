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


### 3. 動作確認
#### イベント登録
```
curl -XPOST -H "Content-Type: application/json"  http://localhost/sportsevent/v1/api/event -d'{"title":"ボッチャ体験会Part2","timeFrom":"2023-05-21 12:00","timeTo":"2023-05-21 15:00","ownerId":"xxxxx_owner_xxxx_id", "comment":"どなたでも参加いただけます","eventType":1, "sportEventIdList":[1,2]}'
```
#### イベント情報取得のリクエスト
```
curl -XGET http://localhost/sportsevent/v1/api/event?eventId=2
```

#### 備品予約
```
curl -XPOST -H "Content-Type: application/json"  http://localhost/equipment-rental/v1/api/equipment-reserve -d'{"equipmentList":[{"equipmentId":1,"equipmentN":3}],"eventId":1,"renterId":"UPxxxxxxxxxxxxxx01","startDate":"2023-03-25 00:00:00","endDate":"2023-03-26 00:00:00","usageDate":"2023-03-26 00:00:00","comment":"何かコメント"}'
```

