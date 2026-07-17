#!/bin/sh
echo "<h1>Container Details</h1>" > /usr/share/nginx/html/index.html
echo "<p><strong>Hostname:</strong> $(hostname)</p>" >> /usr/share/nginx/html/index.html
echo "<p><strong>Internal IP:</strong> $(hostname -i)</p>" >> /usr/share/nginx/html/index.html
nginx -g 'daemon off;'
