#
# Exercise 1
#

# I am using my local Ubuntu Desktop 22.04.5 LTS
# Step 1: Update the apt package index
sudo apt-get update

# Step 2: Install required packages
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Step 3: Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Step 4: Set up the Docker APT repository
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 5: Update the package index again and install Docker Engine
sudo apt-get update

# Step 6: Install Docker Engine
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker versión
docker --version

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker now
sudo systemctl start docker

# Check Docker status
sudo systemctl status Docker

# Show Docker version info
docker version

# Show detailed Docker system info
docker info


#
# Exercise 2
#

# Search official images
docker search ubuntu --filter "is-official=true"
docker search alpine --filter "is-official=true"
docker search nginx --filter "is-official=true"

# Pull the Official Nginx Image
docker pull nginx

# Run the Nginx Container
docker run --name my-nginx -d -p 8080:80 nginx
•	--name my-nginx → Names the container my-nginx.
•	-d → Runs in detached mode (background).
•	-p 8080:80 → Maps host port 8080 to container port 80

# Verify It’s Running
docker ps

#
# Exercise 3
#

sudo systemctl status docker

sudo systemctl stop docker
# To full stop
sudo systemctl stop docker.socket
sudo systemctl stop docker.service

# verify it is stopped
sudo systemctl status Docker

# Try running an Alpine container
docker run alpine echo "Hello"
docker run hello-world

sudo systemctl start Docker
sudo systemctl status Docker

# Now try to run a container again
docker run hello-world
docker run alpine echo "Hello, Docker is back online!"

#
# Exercise 4
#

# Start an interactive Ubuntu container with a Bash shell
docker run -it ubuntu bash

# Inside the container, run
apt update && apt install -y curl

# Verify installation
curl --version

exit

# Restart the stopped container in detached mode
docker start -ai [container-id]

#
# Exercise 5
#

# To see currently running containers
docker ps

# To show all containers (running + stopped)
docker ps -a
# Filter exited containers
docker ps -a --filter "status=exited"

#
# Exercise 6
#

# Use the -d (detached) flag to run a container in the background
docker run -d --name my_container nginx

# Verify it's running
docker ps

docker pause my_container

# Check status
docker ps

docker unpause my_container

# Check status
docker ps

docker stop my_container

# Check status
docker ps

docker restart my_container

# Check status
docker ps

docker kill my_container
# Kill by ID
sudo docker kill $(sudo docker ps -aqf "name=my_container")

# Check status
docker ps

#
# Exercise 7
#

docker rm -f container_name_or_id 
# Stop first, then remove
docker stop my_nginx && docker rm my_nginx

# Check status
docker ps

#
# Exercise 8
#

docker pull alpine
docker pull ubuntu

docker images
# For more detailed info
docker image ls

#
# Exercise 9
#

docker run --rm alpine echo "hello from alpine"

# Output will show Linux kernel info
docker run --rm busybox uname -a

# Including exited
docker ps -a

#
# Exercise 10
#

docker container prune

# Check containers and status
docker ps

docker image prune -a

docker system df
# More Detailed Inspection
docker system df -v
