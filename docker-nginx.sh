#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker ubuntu
docker run -d -p 8080:80 nginx
