FROM golang:1.21 AS go
WORKDIR /app
COPY . .
RUN go mot tidy
CMD [ "go", "run", "cmd/main.go" ]