#!/bin/bash
source /opt/buildpiper/shell-functions/functions.sh
source /opt/buildpiper/shell-functions/log-functions.sh
source /opt/buildpiper/shell-functions/str-functions.sh
source /opt/buildpiper/shell-functions/file-functions.sh
source /opt/buildpiper/shell-functions/aws-functions.sh
source /opt/buildpiper/shell-functions/git-functions.sh

TASK_STATUS=0

CODEBASE_LOCATION="${WORKSPACE}"/"${CODEBASE_DIR}"
logInfoMessage "I'll do processing at [$CODEBASE_LOCATION]"
sleep  $SLEEP_DURATION
cd  "${CODEBASE_LOCATION}"

TASK_STATUS=0

logInfoMessage "Merging branch ${SRC_BRANCH} to ${TGT_BRANCH}"

CONFLICTING_FILES=`findConflictingFiles ${SRC_BRANCH} ${TGT_BRANCH}`

if [ -z "${CONFLICTING_FILES}" ]; then
    TASK_STATUS=0
    logInfoMessage "${SRC_BRANCH} can be merged back into ${TGT_BRANCH}, please continue"
else
    TASK_STATUS=1
    logErrorMessage "${SRC_BRANCH} can't be merged into ${TGT_BRANCH} becasue of conflicts"
    logInfoMessage "Files in conflicting mode are ${CONFLICTING_FILES}"

    logInfoMessage "Listing out the authors of conflicting files in source branch: ${SRC_BRANCH}"
    getLastAuthorOfFiles ${SRC_BRANCH} "${CONFLICTING_FILES}"
    logInfoMessage "Listing out the authors of conflicting files in target branch: ${TGT_BRANCH}"
    getLastAuthorOfFiles ${tgt_BRANCH} "${CONFLICTING_FILES}"
fi
saveTaskStatus ${TASK_STATUS} ${ACTIVITY_SUB_TASK_CODE}