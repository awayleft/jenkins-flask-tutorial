FROM ubuntu:latest
#FROM python:3.7-alpine
LABEL maintainer="howie_howerton@trendmicro.com"
# Note:  Remove the comments for the RUN instructions below when using 'FROM ubuntu:latest'
#RUN apt-get update -y
#RUN apt upgrade -y
RUN apt-get install -y python-pip python-dev build-essential
ADD . /flask-app
WORKDIR /flask-app
RUN pip install -r requirements.txt
RUN echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > eicar.txt
ENTRYPOINT ["python"]
CMD ["flask-docker.py"]
