# pyclient

```shell
SERVER_ADDR=1.1.1.1
SERVER_PORT=7777

docker build -t samp-client-docker .
docker run -it -e SERVER_ADDR=${SERVER_ADDR} -e SERVER_PORT=${SERVER_PORT} samp-client-docker

docker run -it -e SERVER_ADDR=1.1.1.1 -e SERVER_PORT=7777 samp-client-docker
 ```
