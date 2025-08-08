FROM alpine:3.22

RUN apk add aws-cli
RUN apk add helm
RUN apk add kubectl

WORKDIR /root/

CMD ["/bin/bash"]
