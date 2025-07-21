ARG NODE_VERSION=22.0.0
FROM node:${NODE_VERSION}-alpine

WORKDIR /opt/app

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.npm to speed up subsequent builds.
# Leverage a bind mounts to package.json and package-lock.json to avoid having to copy them into
# into this layer.


# Copy the rest of the source files into the image.
COPY app/ .
RUN npm install
# Expose the port that the application listens on.
EXPOSE 8000

# Run the application.
#CMD node server.js
CMD [ "node", "server.js"]
