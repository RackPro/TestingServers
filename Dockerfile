FROM ubuntu:latest

RUN apt update
RUN apt-get update
RUN apt install sysbench -y
RUN apt install stress-ng -y
RUN apt install postgresql postgresql-client -y
RUN apt install vim -y
RUN apt install htop -y

COPY htoprc ./root/.config/htop/

WORKDIR /tests
COPY test.sh ./
COPY config.sh ./

CMD [ "" ]
