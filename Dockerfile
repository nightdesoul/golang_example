FROM golang:alpine as build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags "-extldflags '-static'" -o /main

FROM alpine:latest
COPY --from=build /main /
CMD ["/main"]