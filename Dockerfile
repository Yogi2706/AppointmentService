# syntax=docker/dockerfile:1
FROM node:18-alpine

WORKDIR /app

ENV NODE_ENV=production \
    PORT=3002

COPY package*.json ./
RUN npm install --omit=dev

COPY . .

EXPOSE 3002

CMD ["npm", "start"]
