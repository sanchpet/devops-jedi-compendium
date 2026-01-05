FROM node:22-slim AS builder

WORKDIR /usr/src/app

COPY quartz/ .
COPY content ./content

RUN npm ci && npx quartz build

FROM nginxinc/nginx-unprivileged:alpine

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /usr/src/app/public /usr/share/nginx/html

EXPOSE 8080
