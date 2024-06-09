FROM node:18-alpine3.20 AS builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn

COPY . .

RUN yarn run build
RUN yarn install --production && yarn cache clean

FROM node:18-alpine3.20

WORKDIR /app

COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next

EXPOSE 3000

CMD [ "yarn", "run", "start" ]