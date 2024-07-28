ARG IMAGE

FROM ${IMAGE}

WORKDIR /home/repackage

COPY build_ut.sh .
COPY repackage.sh .
# RUN --mount=type=bind,target=. ./build_ut.sh
# RUN --mount=type=bind,target=. ./repackage.sh

