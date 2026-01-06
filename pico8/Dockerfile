FROM busybox:1.35

LABEL org.opencontainers.image.source=https://github.com/jcambass/ssp
LABEL org.opencontainers.image.description="SSP in Pico-8"

# Create a non-root user to own the files and run our server
RUN adduser -D static
USER static
WORKDIR /home/static

# Copy index.html and ssp.js
COPY index.html ssp.js ./

# Run BusyBox httpd
CMD ["busybox", "httpd", "-f", "-v", "-p", "5000"]