# File used for Identidock Unit tests in Jenkins

# Default compose args
COMPOSE_ARGS=" -f jenkins.yml -p jenkins "

# Make sure old containers are gone
sudo docker-compose $COMPOSE_ARGS stop
sudo docker-compose $COMPOSE_ARGS rm --force -v

# Build the system
sudo docker-compose $COMPOSE_ARGS build --no-cache
sudo docker-compose $COMPOSE_ARGS up -d

# Run unit tests
sudo docker-compose $COMPOSE_ARGS run --no-deps --rm \
                    -e ENV=UNIT identidock
#docker run -v /var/run/docker.sock:/var/run/docker.sock -e ENV=UNIT jenkins_identidock
ERR=$?

ERR=$?

# Run system test if unit tests passed
if [[ $ERR == 0 ]]; then
	IP=$(sudo docker inspect -f {{.NetworkSettings.IPAddress}} \
         jenkins_identidock_1)
    CODE=$(curl -sL -w "%{http_code}" $IP:9090/monster/bla -o /dev/null) \
       || true
    if [[ $CODE != 200 ]; then
    	echo "Site returned " $Code
       	ERR=1
    fi
fi

# Pull down the system
sudo docker-compose $COMPOSE_ARGS stop
sudo docker-compose $COMPOSE_ARGS rm --force -v

return $ERR
