FROM node:slim

LABEL MAINTAINER="Daniel Schroeder <deemes79@googlemail.com>"

ENV AWS_DEFAULT_REGION us-west-1

WORKDIR /workdir

RUN apt-get update && \
    apt-get -y install less zip curl make && \
    apt-get clean

RUN npm install -g typescript
RUN npm install -g aws-cdk

RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

ADD entrypoint /entrypoint

ENTRYPOINT [ "/entrypoint" ]

CMD [ "cdk", "deploy", "--require-approval", "never" ]
