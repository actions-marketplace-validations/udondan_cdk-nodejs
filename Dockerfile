FROM node:slim

LABEL MAINTAINER="Daniel Schroeder <deemes79@googlemail.com>"

ENV AWS_DEFAULT_REGION us-east-1

RUN apt-get update && \
    apt-get -y install less zip curl make && \
    apt-get clean

RUN npm install -g typescript
RUN npm install -g aws-cdk

ADD entrypoint /entrypoint

ENTRYPOINT [ "/entrypoint" ]

CMD [ "cdk", "deploy", "--require-approval", "never" ]
