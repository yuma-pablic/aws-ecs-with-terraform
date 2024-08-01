FROM golang:1.22 AS go
WORKDIR /app
COPY . .
RUN cd api && go mod tidy
CMD [ "go", "run", "cmd/main.go" ]