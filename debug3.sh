#!/bin/bash
SSH_KEY=~/.ssh/lawpoint-key.pem
SERVER=ubuntu@44.214.128.112

ssh -i $SSH_KEY $SERVER << 'REMOTE'
echo "=== Jenkins container inspect ==="
docker inspect jenkins --format '{{.HostConfig.Binds}}'
echo ""
docker inspect jenkins --format '{{.Config.Image}}'
echo ""
docker inspect jenkins --format '{{.HostConfig.PortBindings}}'
echo ""
echo "=== Env vars ==="
docker inspect jenkins --format '{{.Config.Env}}' 
echo ""
echo "=== Container run command ==="
docker inspect jenkins --format '{{.Config.Cmd}}'
echo ""
echo "=== Mounts ==="
docker inspect jenkins --format '{{json .Mounts}}' | python3 -m json.tool 2>/dev/null || docker inspect jenkins --format '{{json .Mounts}}'
echo ""
echo "=== Jenkins home contents ==="
docker exec jenkins ls /var/jenkins_home/ | head -20
REMOTE
