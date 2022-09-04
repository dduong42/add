FROM python:alpine AS builder
RUN adduser --home /home/builder --disabled-password builder
RUN apk add --no-cache nasm \
	lld \
	make
USER builder
WORKDIR /home/builder
COPY Makefile /home/builder
COPY print.s /home/builder
COPY compile /home/builder
COPY source /home/builder
RUN make LD=ld.lld

FROM alpine:latest
COPY --from=builder /home/builder/add /usr/local/bin
USER nobody
CMD ["add"]
