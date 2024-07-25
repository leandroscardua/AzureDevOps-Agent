FROM alpine:3.17.9

RUN apk update && apk upgrade && apk add --no-cache bash

ENV TARGETARCH="linux-musl-x64"

# # Install tools
COPY ./tools/install-tools.sh ./
RUN chmod +x ./install-tools.sh && ./install-tools.sh

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN adduser -D agent && chown agent ./
USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh