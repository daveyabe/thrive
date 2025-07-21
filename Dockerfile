ARG NODE_VERSION=22.0.0
FROM node:${NODE_VERSION}-alpine
WORKDIR /opt/app
COPY app/ .
RUN npm install
EXPOSE 8000

# Run the application.
#CMD node server.js
CMD [ "node", "server.js"]
