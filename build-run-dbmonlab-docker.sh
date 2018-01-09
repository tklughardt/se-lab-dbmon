# Builds the DB Mon Lab image and runs a container.

# Deletes the DB Mon Lab containers and images and recreates them.
# Consider getting rid of at least the last one, since it always pulls 8 GB. At least that one can stay without any issues.
docker stop $(docker ps -qaf name=se-lab-dbmon)
docker rm $(docker ps -qaf name=se-lab-dbmon)
docker rmi $(docker images pistensau/dbmon_lab_instance -q)
docker rmi $(docker images pistensau/dbmonlab -q)

if [ ! -f controller.env ]; then
  echo "Can't find controller.env, exitting..."
  exit 1
else
  echo "Sourcing controller env...."
  . ./controller.env
fi

echo "Controller Host is"
echo ${CONTROLLER_HOST}

### builds the docker image ###
echo "docker build -t pistensau/dbmon_lab_instance \
  --build-arg CONTROLLER_HOST=${CONTROLLER_HOST} \
  --build-arg CONTROLLER_PORT=${CONTROLLER_PORT} \
  --build-arg SSL_ENABLED=${SSL_ENABLED} \
  --build-arg ACCOUNT_NAME=${ACCOUNT_NAME} \
  --build-arg ACCOUNT_ACCESS_KEY=${ACCOUNT_ACCESS_KEY} \
  --build-arg APPD_AGENT_VERSION=${APPD_AGENT_VERSION} ."

docker build -t pistensau/dbmon_lab_instance \
  --build-arg CONTROLLER_HOST=${CONTROLLER_HOST} \
  --build-arg CONTROLLER_PORT=${CONTROLLER_PORT} \
  --build-arg SSL_ENABLED=${SSL_ENABLED} \
  --build-arg ACCOUNT_NAME=${ACCOUNT_NAME} \
  --build-arg ACCOUNT_ACCESS_KEY=${ACCOUNT_ACCESS_KEY} \
  --build-arg APPD_AGENT_VERSION=${APPD_AGENT_VERSION} .
#
docker run -p 1521:1521\
 --name se-lab-dbmon \
 pistensau/dbmon_lab_instance
