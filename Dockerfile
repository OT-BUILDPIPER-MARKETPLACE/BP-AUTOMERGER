FROM alpine

# Create non-root user and group (UID 65522 like referenced sample)
RUN addgroup -g 65522 buildpiper && \
    adduser -u 65522 -G buildpiper -D -h /home/buildpiper buildpiper

# Create required directories and set permissions
RUN mkdir -p \
    /opt/buildpiper/shell-functions \
    /opt/buildpiper/data \
    /bp/workspace \
    /src \
    /home/buildpiper && \
    chown -R buildpiper:buildpiper /opt /bp /src /home/buildpiper /tmp

# Install dependencies
RUN apk add --no-cache \
    bash jq git python3 py3-pip py3-virtualenv

# Create venv and install csvkit
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir csvkit

# Use the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Copy files with correct ownership
WORKDIR /src
COPY --chown=buildpiper:buildpiper build.sh .
COPY --chown=buildpiper:buildpiper BP-BASE-SHELL-STEPS /opt/buildpiper/shell-functions/

# ENV variables
ENV SLEEP_DURATION 5s
ENV SRC_BRANCH dev
ENV TGT_BRANCH main
ENV ACTIVITY_SUB_TASK_CODE BP-AUTOMERGER
ENV VALIDATION_FAILURE_ACTION WARNING

# Git config for non-root user
USER buildpiper
RUN git config --global user.email "connect@opstree.com" && \
    git config --global user.name "Buildpiper"

# ENTRYPOINT
ENTRYPOINT ["./build.sh"]
