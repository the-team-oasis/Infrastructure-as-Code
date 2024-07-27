FROM node:14
#Create a working directory
WORKDIR /function
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
RUN npm install
# Copy all artifacts including generated ones
COPY . /function/
CMD [ "node", "func.js" ]
