FROM --platform=$BUILDPLATFORM quay.io/projectquay/golang:1.23 AS builder
ARG PLATFORM
ARG ARCH

WORKDIR /src
COPY . .

RUN CGO_ENABLED=0 GOOS=${PLATFORM} GOARCH=${ARCH} go build -o app

FROM scratch
COPY --from=builder /src/app .
ENTRYPOINT [ "/app" ]