# 构建前端资源
FROM node:18-bookworm-slim as node-builder

WORKDIR /mayfly

COPY mayfly_go_web .

RUN yarn install && \
    yarn build

FROM nginx:stable-alpine AS nginx-builder
COPY --from=node-builder /mayfly/dist /usr/share/nginx/html
COPY mayfly_go_web/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
