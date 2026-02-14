docker login -u subhaniuduwawala

docker build -t subhaniuduwawala/lawpoint-backend:latest .
docker build -t subhaniuduwawala/lawpoint-frontend:latest .

docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest