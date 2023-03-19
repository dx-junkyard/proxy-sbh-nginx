

clean_up()
{
TARGET=${1}
if [ -e ./${TARGET}.jar ]; then
rm ./${TARGET}
fi

if [ -d ./${TARGET} ]; then
rm -rf ./${TARGET}
fi
}


# 1. gitからDB構築スクリプトを取得する
echo "step1"
TARGET=sports-barrier-free-mysql
clean_up ${TARGET}
git clone https://github.com/dx-junkyard/${TARGET}.git


# 2. Dockerファイルの生成
#  - Docker-build.xxx : jarファイル生成用のbuild環境
#  - Docker-run.xxx : docker-composeで起動される各サービスimage生成用のDockerfile
echo "step2: create dockerfile"
cat service_list.txt | while read TARGET
do
echo "TARGET=${TARGET}"
#clean_up ${TARGET}
sed "s/GIT-REPOSITORY-NAME-XXX/${TARGET}/g" ./templates/Dockerfile-build.template > Docker-build.${TARGET}
sed "s/GIT-REPOSITORY-NAME-XXX/${TARGET}/g" ./templates/Dockerfile-run.template > Docker-run.${TARGET}
done

# 3. 2で生成したDocker-build.xxxによりコンテナを起動してjarファイル生成
echo "step3: create build-docker-image"
cat service_list.txt | while read TARGET
do
docker build -t ${TARGET}-build -f Docker-build.${TARGET} .
done

# 4. imageを起動してjarファイルを取り出す
echo "step4: build"
cat service_list.txt | while read TARGET
do
echo "---------- ${TARGET} ----------"
docker run --rm -v $(pwd):/output -p 8080:8080 ${TARGET}-build
done

# 5. 各サービスのコンテナimageを生成
echo "step5: create run-docker-image"
cat service_list.txt | while read TARGET
do
echo "---------- ${TARGET} ----------"
docker build -t ${TARGET} -f Docker-run.${TARGET} .
done


# 6. DBと各サービスの起動
echo "step6: create docker-compose.yaml"
cp templates/DockerComposeBaseTemplate.yaml ./docker-compose.yaml
cat service_list.txt | while read TARGET
do
APP_NAME=`echo "${TARGET}" | sed 's/-spring/-app/g'`
sed "s/GIT-REPOSITORY-NAME-XXX/${TARGET}/g" ./templates/DockerComposeServiceTemplate.yaml | sed "s/GIT-REPOSITORY-NAME-APP/${APP_NAME}/g" >> ./docker-compose.yaml
echo "---------- ${TARGET} ----------"
docker build -t ${TARGET} -f Docker-run.${TARGET} .
done


