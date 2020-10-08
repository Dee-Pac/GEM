echo "Pulling neo4j docker image ..."

docker pull neo4j:latest

echo "Starting neo4j container ..."

docker run neo4j:latest
