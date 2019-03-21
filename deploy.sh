#Build images
docker build -t gaurav2730/multi-container-client:latest -t gaurav2730/multi-container-client:$SHA -f ./client/Dockerfile ./client
docker build -t gaurav2730/multi-container-server:latest -t gaurav2730/multi-container-server:$SHA -f ./server/Dockerfile ./server
docker build -t gaurav2730/multi-container-worker:latest -t gaurav2730/multi-container-worker:$SHA -f ./worker/Dockerfile ./worker

#Push images to docker hub
docker push gaurav2730/multi-container-client:latest
docker push gaurav2730/multi-container-server:latest
docker push gaurav2730/multi-container-worker:latest

docker push gaurav2730/multi-container-client:$SHA #SHA is the Head value obtained from git checkin
docker push gaurav2730/multi-container-server:$SHA
docker push gaurav2730/multi-container-worker:$SHA

#Apply all configs on k8s folder
kubectl -apply -f k8s
#Imperatively set latest image on each deployments
kubectl set image deployments/server-deployment server=gaurav2730/multi-container-server:$SHA
kubectl set image deployments/client-deployment client=gaurav2730/multi-container-client:$SHA
kubectl set image deployments/worker-deployment worker=gaurav2730/multi-container-worker:$SHA