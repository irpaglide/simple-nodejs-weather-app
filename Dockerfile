FROM node:8
ARG OW_API_KEY
ENV ENV_OW_API_KEY=$OW_API_KEY
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --save request 
RUN npm install --save express
RUN npm install --save ejs
COPY . .
EXPOSE 3000
ENTRYPOINT ["node", "server.js"]
