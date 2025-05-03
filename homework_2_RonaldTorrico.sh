#
# Exercise 1
#

# 1. List all Docker networks.
docker network ls

# 2. Inspect the default bridge network.
docker network inspect bridge

# 3. Create a new bridge user-defined network.
docker network create --driver bridge my_bridge_network

# 4. Run a container attached to it and inspect its IP.
# Run a container (using Alpine as an example)
docker run -dit --name my_container --network my_bridge_network alpine sh

# Inspect its IP (either by inspecting the container or the network)
docker inspect my_container | grep IPAddress
# OR
docker network inspect my_bridge_network | grep -A 5 my_container

#
# Exercise 2
#
# 1. Run two Nginx containers which have to be connected to that user-defined network created in Exercise 1.

# Run the first Nginx container
docker run -d --name nginx1 --network my_bridge_network nginx
# Run the second Nginx container
docker run -d --name nginx2 --network my_bridge_network nginx

docker ps

# Verify both containers are running and connected to the network
docker network inspect my_bridge_network

# Test connectivity between them (optional):
# Exec into nginx1 and ping nginx2 (requires ping utility)
docker exec -it nginx1 sh -c "apt-get update && apt-get install -y iputils-ping && ping nginx2"

# 2. Use ping within both containers to test communication each other by container name.
# Install ping in nginx1 and nginx2
docker exec -it nginx1 bash -c "apt-get update && apt-get install -y iputils-ping"
docker exec -it nginx2 bash -c "apt-get update && apt-get install -y iputils-ping"

# Test communication using ping
docker exec -it nginx1 ping nginx2

#
# Exercise 3
#
# 1. Create a Docker volume: mydata .
docker volume create mydata
docker volume ls

 
# 2. Run a container using the volume.
# Mount mydata to /data inside the container
docker run -it --name mycontainer -v mydata:/data alpine sh

 
# 3. Write a file inside /data from the container, then:
echo "Hello world" > /data/test.txt
cat /data/test.txt
exit

# 1. Stop the container.
docker stop mycontainer

# 2. Relaunch to verify persistence.
docker run -it --name newcontainer -v mydata:/data alpine sh
cat /data/test.txt

#
# Exercise 4
#
# 1. Create a directory on your host.
mkdir ~/host_data

# 2. Run a container with a bind mount.
docker run -it --name bind_container -v ~/host_data:/mnt alpine sh

# 3. Create a file in /mnt from the container and check the host.
echo "Hello from the container!" > /mnt/container_file.txt
cat /mnt/container_file.txt
exit

cat ~/host_data/container_file.txt

#
# Exercise 1
#
# 1. Create a file in a named volume.
# Create a named volume
docker volume create my_vol

# Run a container, mount the volume to /data, and create a file
docker run -it --name vol_container -v my_vol:/data alpine sh -c "echo 'Stored in a named volume' > /data/vol_file.txt && cat /data/vol_file.txt"

# Inspect where Docker stores the volume data
docker volume inspect my_vol

# 2. Create a file using a bind mount.
# Create a host directory
mkdir ~/bind_data

# Run a container, bind mount the host dir to /mnt, and create a file
docker run -it --name bind_container -v ~/bind_data:/mnt alpine sh -c "echo 'Stored in a bind mount' > /mnt/bind_file.txt && cat /mnt/bind_file.txt"

# Check the file on the host
ls ~/bind_data && cat ~/bind_data/bind_file.txt

# 3. Observe where data is stored on the host with docker volume inspect and ls .
docker volumen ls
docker volumen inspect mydata

#
# Exercise 6
#
# 1. Run an Ubuntu container with the necessary options to enable Docker in Docker (DinD).

docker run --privileged --name dind_container -d docker:dind
# •--privileged: Grants full host system access (required for DinD).
# •-d: Runs the container in detached mode.

# 2. Exec into the container and run docker version .
docker exec -it dind_container sh -c "docker version"

#
# Exercise 7
#
# 1. Run a container with memory and CPU limits:
#    1. Memory = 256m
#    2. CPU = 0.5

docker run -d --name limited_container \
  --memory="256m" \           # Memory limit: 256MB
  --cpus="0.5" \                     # CPU limit: 0.5 cores (50% of a CPU)
  nginx                                   # Using Nginx for demonstration

# 2. Check resource usage stats .
docker stats limited_container

# 3. Check disk usage (docker system).
docker system df
docker inspect limited_container | grep -iE "memory|cpu"

#
# Exercise 8
#
# 1. Run a container with policy --restart on-failure .

docker run -d --name on_failure_container --restart on-failure alpine sleep 30
# • The sleep 30 command will exit after 30 seconds.
# • Since it exits successfully (exit code 0), Docker will not restart it (only restarts on failures, i.e., non-zero exit codes).

# 2. Kill the container and observe how it restarts
docker start on_failure_container                          # Restart it (if stopped)
docker exec on_failure_container sh -c "exit 1"    # Force a failure
docker kill on_failure_container                            # Sends SIGKILL (immediate termination)

# 3. Try with the policy --restart unless-stopped
docker run -d --name unless_stopped_container --restart unless-stopped alpine sleep 30
docker logs unless_stopped_container                                             # Shows sleep exits after 30s
docker ps -a --filter "name=unless_stopped_container" --format "{{.Status}}"

# 4. Reboot the system and see what happens.
docker ps -a --filter "name=unless_stopped_container"

#
# Exercise 9
#
# 1. Create a network dbnet .
docker network create dbnet

#2. Create a volume dbdata .
docker volume create dbdata

# 3. Run a MariaDB container with the following requirements:
#    1. Attached to volume dbdata .
#    2. Attached to network dbnet . 
#    3. Do NOT expose ANY port.

docker run -d --name mariadb --network dbnet \
  -v dbdata:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  Mariadb

docker inspect mariadb-container | grep dbnet
docker volume inspect dbdata

#
# Exercise 10
#
# 1. Run a PHPMyAdmin container with the following requirements:
#    1. Attached to network dbnet (created in Exercise 9).
#    2. Use a bind mount to persist the web app configuration.
#    3. Linked to the previous MariaDB container (created in Exercise 9)
#    4. Open a browser to display the PHPMyAdmin Login Form.
#    5. Login with the DB credentials.

docker run -d \
  --name phpmyadmin \
  --network dbnet \
  --link mariadb-container:db \
  -v ~/phpmyadmin-config:/etc/phpmyadmin/config.user.inc.php \
  -e PMA_HOST=mariadb-container \
  -e PMA_PORT=3306 \
  -p 8080:80 \
  phpmyadmin/phpmyadmin
