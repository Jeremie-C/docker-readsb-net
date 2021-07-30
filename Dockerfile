FROM debian:buster-slim

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  # Required always
  curl libncurses6 net-tools jq bc \
  # S6 Install
  ca-certificates wget \
  # Readsb
  git build-essential libncurses-dev zlib1g-dev && \
  # S6 OVERLAY
  chmod +x /scripts/s6-overlay.sh && \
  /scripts/s6-overlay.sh && \
  rm /scripts/s6-overlay.sh && \
  chmod +x /healthcheck.sh && \
  git clone --branch=dev --single-branch --depth=1 https://github.com/wiedehopf/readsb.git /src/readsb && \
  pushd /src/readsb || exit 1 && \
  make RTLSDR=no HAVE_BIASTEE=no BLADERF=no PLUTOSDR=no AGGRESSIVE=no && \
  cp -v /src/readsb/readsb /usr/bin/readsb && \
  cp -v /src/readsb/viewadsb /usr/bin/viewadsb && \
  popd && \
  mkdir -p /var/readsb/ && \
  apt-get remove -y git build-essential libncurses-dev zlib1g-dev && \
  apt-get autoremove -y && \
  rm -rf /src/* /scripts /var/lib/apt/lists/*

ENTRYPOINT ["/init"]

EXPOSE 30005/tcp
VOLUME ["/var/readsb/"]

HEALTHCHECK --start-period=60s --interval=300s CMD /healthcheck.sh
LABEL maintainer="Jeremie-C <Jeremie-C@users.noreply.github.com>"
