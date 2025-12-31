FROM node:22-slim AS builder

WORKDIR /usr/src/app

COPY quartz/ .

RUN npm ci && npx quartz build

FROM nginxinc/nginx-unprivileged:alpine

COPY --from=builder /usr/src/app/public /usr/share/nginx/html

EXPOSE 8080
