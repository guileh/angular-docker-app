FROM alpine:3.10

# S.O. deps
RUN \
    apk add --no-cache --virtual\
    bash \
    nginx=1.16.1-r2 \
    supervisor=3.3.5-r0 \
    build-base=0.5-r1 \
    make=4.2.1-r2 \
    g++=8.3.0-r0 \
    gcc=8.3.0-r0 \
    nodejs=10.19.0-r0 \
    npm=10.19.0-r0

# Prepare to use Angular 9
COPY . /project
RUN mkdir /app
RUN npm install @angular/cli@9.0.4 -g

# Build Project in dev and prod version
WORKDIR /project
RUN npm install && \
    ng build && \
    mv /project/dist/angular-docker-app /app/angular-docker-app && \
    npm cache clean --force

# Cache clear
RUN apk del --no-cache \
    make \
    g++ \
    gcc \
    npm \
    nodejs && \
    apk update && \
    rm /etc/nginx/conf.d/default.conf && \
    rm -rf /project

# Copy the Nginx global conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY vhost.conf /etc/nginx/conf.d/
COPY entrypoint.sh /app/entrypoint.sh

# Custom Supervisord config
COPY supervisord.conf /etc/supervisord.conf

# Run application
WORKDIR /app
RUN chown -R nginx:nginx /app && chmod 755 /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]

