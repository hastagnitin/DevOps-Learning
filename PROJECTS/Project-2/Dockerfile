FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY entrypoint.sh /entrypoint.sh

RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid && \
    chown nginx:nginx /entrypoint.sh

USER nginx
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
