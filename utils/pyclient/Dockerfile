FROM python:3

ARG SERVER_ADDR=127.0.0.0
ARG SERVER_PORT=7777

ENV SERVER_ADDR=${SERVER_ADDR}
ENV SERVER_PORT=${SERVER_PORT}

COPY ./ /home/debian/

RUN pip install samp_client --root-user-action ignore 

ENTRYPOINT /home/debian/server-client.py ${SERVER_ADDR} ${SERVER_PORT}
