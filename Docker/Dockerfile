FROM alpine:3.19
RUN apk add --no-cache bash gawk coreutils
WORKDIR /workspace
COPY returns_processor.sh /usr/local/bin/returns_processor.sh
RUN chmod +x /usr/local/bin/returns_processor.sh
CMD ["bash", "/usr/local/bin/returns_processor.sh"]
