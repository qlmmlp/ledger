FROM nginx:alpine as base

# Development stage
FROM base as dev
# Copy configuration files
COPY ./conf/default.conf /etc/nginx/conf.d/

# Production stage
FROM base as prod
# Copy configuration files
COPY ./conf/staging.conf /etc/nginx/conf.d/

# Common configuration for both stages
USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
