FROM alpine
RUN apk add --no-cache --upgrade bash
RUN apk add jq
COPY build.sh .

ADD BP-BASE-SHELL-STEPS /opt/buildpiper/shell-functions/


ENV SLEEP_DURATION 5s

ENV SRC_BRANCH dev
ENV TGT_BRANCH main

ENV ACTIVITY_SUB_TASK_CODE BP-AUTOMERGER
ENV VALIDATION_FAILURE_ACTION WARNING

ENTRYPOINT [ "./build.sh" ]