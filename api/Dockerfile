FROM golang:1.22 AS go
WORKDIR /app
COPY . .
RUN go mod init
RUN go mod tidy
CMD [ "go", "run", "cmd/main.go" ]