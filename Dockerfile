FROM nginx:stable-alpine

# Copy the build folder
COPY build/ /usr/share/nginx/html

# Remove the default config
RUN rm /etc/nginx/conf.d/default.conf

# Create the new config using printf (more compatible)
RUN printf 'server {\n\
    listen 80;\n\
    location / {\n\
        root /usr/share/nginx/html;\n\
        index index.html index.htm;\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
