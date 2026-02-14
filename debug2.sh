#!/bin/bash
SSH_KEY=~/.ssh/lawpoint-key.pem
SERVER=ubuntu@44.214.128.112

ssh -i $SSH_KEY $SERVER << 'REMOTE'
echo "=== Check /tmp inside container ==="
docker exec jenkins ls -la /tmp/
docker exec jenkins mount | grep tmp

echo ""
echo "=== Java spawn helper ==="
docker exec jenkins find / -name "jspawnhelper" 2>/dev/null
docker exec jenkins ls -la $(docker exec jenkins find / -name "jspawnhelper" 2>/dev/null) 2>&1

echo ""
echo "=== Test git inside container ==="
docker exec jenkins git --version 2>&1
docker exec jenkins git init /tmp/test-repo 2>&1

echo ""
echo "=== Jenkins HOME caches ==="
docker exec jenkins ls -la /var/jenkins_home/caches/ 2>&1

echo ""
echo "=== ulimits ==="
docker exec jenkins sh -c "ulimit -a" 2>&1
REMOTE
