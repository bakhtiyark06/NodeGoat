FROM node:20-alpine AS deps

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --omit=dev


FROM node:20-alpine AS runner

ENV NODE_ENV=production
ENV PORT=4000
ENV MONGODB_URI=mongodb://mongodb:27017/nodegoat

WORKDIR /home/node/app

COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --chown=node:node . .

USER node

EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO- http://localhost:4000/login || exit 1

CMD ["npm", "start"]