FROM debian:buster-slim

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  # Required always
  gawk libncurses6 net-tools jq bc \
  # S6 Install
  ca-certificates wget \
  # Readsb
  git build-essential libncurses-dev zlib1g-dev && \
  # S6 OVERLAY
  chmod +x /scripts/s6-overlay.sh && \
  /scripts/s6-overlay.sh && \
  rm /scripts/s6-overlay.sh

RUN git clone --branch=dev --single-branch --depth=1 https://github.com/wiedehopf/readsb.git /tmp/readsb && \
  pushd /tmp/readsb || exit 1 && \
  make RTLSDR=no HAVE_BIASTEE=no BLADERF=no PLUTOSDR=no AGGRESSIVE=no && \
  cp -v /tmp/readsb/readsb /usr/bin/readsb && \
  cp -v /tmp/readsb/viewadsb /usr/bin/viewadsb && \
  echo "readsb $(/usr/bin/readsb --version)" >> /VERSIONS && \
  readsb --version | cut -d ' ' -f2- > /CONTAINER_VERSION && \
  popd && \
  mkdir /run/readsb

# Nettoyage
RUN apt-get remove -y ca-certificates wget git build-essential libncurses-dev zlib1g-dev && \
  apt-get autoremove -y && \
  rm -rf /tmp/* /var/lib/apt/lists/*

ENTRYPOINT ["/init"]

HEALTHCHECK --start-period=3600s --interval=600s CMD /scripts/healthcheck.sh

LABEL maintainer="Jeremie-C <Jeremie-C@users.noreply.github.com>"
