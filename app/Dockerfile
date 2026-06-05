FROM node:22-alpine

WORKDIR /app
COPY package.json ./
COPY server.js ./
COPY auth.js ./
COPY public ./public
COPY recovered-games ./recovered-games
COPY vendor ./vendor

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

CMD ["node", "server.js"]
