#!/usr/bin/env bash
set -e
EXITCODE=0

if [ -f "/run/readsb/aircraft.json" ]; then
  # get latest timestamp of readsb json update
  TIMESTAMP_LAST_READSB_UPDATE=$(jq '.now' < /run/readsb/aircraft.json)
  # get current timestamp
  TIMESTAMP_NOW=$(date +"%s.%N")
  # makse sure readsb has updated json in past 60 seconds
  TIMEDELTA=$(echo "$TIMESTAMP_NOW - $TIMESTAMP_LAST_READSB_UPDATE" | bc)
  if [ "$(echo "$TIMEDELTA" \< 60 | bc)" -ne 1 ]; then
      echo "readsb last updated: ${TIMESTAMP_LAST_READSB_UPDATE}, now: ${TIMESTAMP_NOW}, delta: ${TIMEDELTA}. UNHEALTHY"
      EXITCODE=1
  else
      echo "readsb last updated: ${TIMESTAMP_LAST_READSB_UPDATE}, now: ${TIMESTAMP_NOW}, delta: ${TIMEDELTA}. HEALTHY"
  fi
else
  echo "ERROR: Cannot find /run/readsb/aircraft.json!"
  EXITCODE=1
fi

# check port 30005 is open
# shellcheck disable=SC2046
if [ $(netstat -an | grep LISTEN | grep -c ":30005") -ge 1 ]; then
   echo "TCP port 30005 open. HEALTHY"
else
   echo "TCP port 30005 not open. UNHEALTHY"
   EXITCODE=1
fi

# shellcheck disable=SC2126
READSB_DEATHS=$(s6-svdt /run/s6/services/readsb | grep -v "exitcode 0" | wc -l)
if [ "$READSB_DEATHS" -ge 1 ]; then
    echo "readsb deaths: $READSB_DEATHS. UNHEALTHY"
    EXITCODE=1
else
    echo "readsb deaths: $READSB_DEATHS. HEALTHY"
fi
s6-svdt-clear /run/s6/services/readsb

exit $EXITCODE
