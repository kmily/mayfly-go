# 构建后端资源
FROM golang:1.22 as be-builder

# ENV GOPROXY https://goproxy.cn
WORKDIR /mayfly

# Copy the go source for building server
COPY server .

RUN go mod tidy && go mod download

# Build
RUN GO111MODULE=on CGO_ENABLED=0 GOOS=linux \
    go build -a -ldflags=-w \
    -o mayfly-go main.go

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y ca-certificates expat libncurses5 && \
    apt-get clean

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /mayfly

COPY --from=be-builder /mayfly/mayfly-go /usr/local/bin/mayfly-go

CMD ["mayfly-go"]
