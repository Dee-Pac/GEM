FROM node:12

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
COPY schema.graphql ./
COPY .env ./
COPY start_serv.sh ./

RUN chmod 755 ./start_serv.sh
RUN npm config set strict-ssl false
RUN npm install --save neo4j-graphql-js apollo-server dotenv

# Bundle app source
COPY . .

EXPOSE 8080
EXPOSE 3000
CMD [ "./start_serv.sh" ]
