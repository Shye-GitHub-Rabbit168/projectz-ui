FROM node:lts as build

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

#ARG REACT_APP_SERVICE_HOST=http://localhost:8080

#docker toolbox - docker engine in linux virtual machine under host system (windows)
# localhost - docker-machine ip (192.168.99.100)
ARG REACT_APP_SERVICE_HOST=http://192.168.99.100:8080 
ENV REACT_APP_SERVICE_HOST $REACT_APP_SERVICE_HOST

WORKDIR /code

COPY package.json /code/package.json
COPY package-lock.json /code/package-lock.json
RUN npm ci

COPY . /code
RUN npm run build



#By default, Nginx looks in the /usr/share/nginx/html directory inside of the 
#  container for files to serve. We need to get our html files into this directory.
#FROM nginx:1.12-alpine
FROM nginx
COPY --from=build /code/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

# ARG PORT=80
# ENV PORT $PORT