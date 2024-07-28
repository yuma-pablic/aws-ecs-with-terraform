FROM golang:1.21 AS go
WORKDIR /app
COPY . .
RUN go mod download
CMD [ "go", "run", "cmd/main.go" ]