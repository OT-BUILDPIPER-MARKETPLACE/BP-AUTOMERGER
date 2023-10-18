FROM alpine
RUN apk add --no-cache --upgrade bash
RUN apk add jq git
COPY build.sh .

ADD BP-BASE-SHELL-STEPS /opt/buildpiper/shell-functions/


ENV SLEEP_DURATION 5s

ENV SRC_BRANCH dev
ENV TGT_BRANCH main

ENV ACTIVITY_SUB_TASK_CODE BP-AUTOMERGER
ENV VALIDATION_FAILURE_ACTION WARNING

RUN git config --global user.email "connect@opstree.com"
RUN git config --global user.name "Buildpiper"

ENTRYPOINT [ "./build.sh" ]