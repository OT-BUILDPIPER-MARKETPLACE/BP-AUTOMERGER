# BP-SHELL-STEP-TEMPLATE
I'll merge the dest branch with the source branch in case of no merge conflict. In case of conflict I'll highlight the conflicted file along with the committer's mail id

## Setup
* Clone the code available at [BP-AUTOMERGER](https://github.com/OT-BUILDPIPER-MARKETPLACE/BP-AUTOMERGER)

* Build the docker image
```
git submodule init
git submodule update
docker build -t ot/bp-automerger:0.1 .
```

* Do local testing
```
docker run -it --rm -v $PWD:/src -e var1="key1" -e var2="key2" ot/<image-name>:0.1
docker run -it --rm -v $PWD:/src -e SRC_BRANCH=v0.1 -e TGT_BRANCH=main -e WORKSPACE="" -e CODEBASE_DIR="src" ot/bp-automerger:0.1
docker run -it --rm -v $PWD:/src -e SRC_BRANCH=src -e TGT_BRANCH=tgt -e WORKSPACE="" -e CODEBASE_DIR="src" ot/bp-automerger:0.1
```

* Debug
```
docker run -it --rm -v $PWD:/src -e WORKSPACE="" -e CODEBASE_DIR="src" --entrypoint bash ot/bp-automerger:0.1

docker run -it --rm -v $PWD:/src -e SRC_BRANCH=v0.1 -e TGT_BRANCH=main -e WORKSPACE="" -e CODEBASE_DIR="src" --entrypoint bash ot/bp-automerger:0.1
```