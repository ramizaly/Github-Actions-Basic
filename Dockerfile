FROM node:18-alpine
WORKDIR /app
COPY ./*.json /app/
RUN npm install --force
#RUN npm audit fix --force
RUN yarn add react-scripts
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
## run start