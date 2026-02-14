#!/bin/bash
SSH_KEY=~/.ssh/lawpoint-key.pem
SERVER=ubuntu@44.214.128.112

ssh -i $SSH_KEY $SERVER << 'REMOTE'
echo "=== Memory ==="
free -h

echo ""
echo "=== /tmp inside Jenkins container ==="
docker exec jenkins df -h /tmp

echo ""
echo "=== Jenkins container disk ==="
docker exec jenkins df -h /

echo ""
echo "=== Java version ==="
docker exec jenkins java -version 2>&1

echo ""
echo "=== Git inside container ==="
docker exec jenkins which git 2>&1
docker exec jenkins git --version 2>&1

echo ""
echo "=== Jenkins cache dir ==="
docker exec jenkins ls -la /var/lib/jenkins/caches/ 2>&1

echo ""
echo "=== Docker system df ==="
docker system df

echo ""
echo "=== Host disk ==="
df -h /
REMOTE
