

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



#echo "step1"
TARGET=sports-barrier-free-mysql
clean_up ${TARGET}
git clone https://github.com/dx-junkyard/${TARGET}.git



echo "step2: create dockerfile"
cat service_list.txt | while read TARGET
do
echo "TARGET=${TARGET}"
#clean_up ${TARGET}
sed "s/GIT-REPOSITORY-NAME-XXX/${TARGET}/g" Dockerfile-build.template > Docker-build.${TARGET}
sed "s/GIT-REPOSITORY-NAME-XXX/${TARGET}/g" Dockerfile-run.template > Docker-run.${TARGET}
done


echo "step3: create build-docker-image"
cat service_list.txt | while read TARGET
do
docker build -t ${TARGET} -f Docker-build.${TARGET} .
done

echo "step4: build"
cat service_list.txt | while read TARGET
do
docker run --rm -v $(pwd):/output -p 8080:8080 ${TARGET}-build
done

echo "step5: create build-docker-image"
cat service_list.txt | while read TARGET
do
docker build -t ${TARGET} -f Docker-run.${TARGET} .
done


