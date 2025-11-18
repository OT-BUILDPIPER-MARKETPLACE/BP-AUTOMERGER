#!/bin/bash
source /opt/buildpiper/shell-functions/functions.sh
source /opt/buildpiper/shell-functions/log-functions.sh
source /opt/buildpiper/shell-functions/str-functions.sh
source /opt/buildpiper/shell-functions/file-functions.sh
source /opt/buildpiper/shell-functions/aws-functions.sh
source /opt/buildpiper/shell-functions/git-functions.sh

TASK_STATUS=0

CODEBASE_LOCATION="${WORKSPACE}/${CODEBASE_DIR}"
logInfoMessage "I'll do processing at [$CODEBASE_LOCATION]"
sleep $SLEEP_DURATION
cd "${CODEBASE_LOCATION}"

logInfoMessage "Detecting source branch containing 'dev'..."

# 1. Find any branch containing keyword dev
MATCHED_BRANCH=$(git branch -a | grep -E "dev" | sed 's/*//g' | tr -d ' ' | head -n 1)

if [ -z "$MATCHED_BRANCH" ]; then
    TASK_STATUS=2   # 2 = WARNING in BuildPiper
    logWarningMessage "No branch found containing keyword 'dev'. Skipping automerge step and continuing pipeline..."
    saveTaskStatus ${TASK_STATUS} ${ACTIVITY_SUB_TASK_CODE}

    # Continue pipeline (no failure)
    exit 0
fi


logInfoMessage "Merging branch ${SRC_BRANCH} to ${TGT_BRANCH}"

# 2. Validate source and target branches
branch_exists ${SRC_BRANCH}
if [ "$?" -eq 0 ]; then

    branch_exists ${TGT_BRANCH}
    if [ "$?" -eq 0 ]; then

        CONFLICTING_FILES=$(findConflictingFiles ${SRC_BRANCH} ${TGT_BRANCH})

        if [ -z "${CONFLICTING_FILES}" ]; then
            TASK_STATUS=0
            logInfoMessage "${SRC_BRANCH} can be merged back into ${TGT_BRANCH}, please continue"
        else
            TASK_STATUS=1
            logInfoMessage "Conflicting files found between ${SRC_BRANCH} and ${TGT_BRANCH}"
            listAuthorsOfFilesAcrossBranches ${SRC_BRANCH} ${TGT_BRANCH} "${CONFLICTING_FILES}"
        fi

    else
        TASK_STATUS=1
        logErrorMessage "Target Branch: ${TGT_BRANCH} doesn't exist, please check!!!"
    fi

else
    TASK_STATUS=1
    logErrorMessage "Source Branch: ${SRC_BRANCH} doesn't exist, please check!!!"
fi

saveTaskStatus ${TASK_STATUS} ${ACTIVITY_SUB_TASK_CODE}
