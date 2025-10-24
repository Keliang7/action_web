# 使用官方的 Node.js 镜像作为基础镜像
FROM node:18.16.0-alpine AS build-stage

# 设置工作目录
WORKDIR /app

RUN npm install -g pnpm@9.14.2

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .

# 构建生产环境下的 Vue 项目
RUN npm run build

# 启动 Vue 项目，这里假设使用的是 http-server 作为静态服务器
FROM nginx:alpine
COPY scripts/nginx/nginx_config.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]