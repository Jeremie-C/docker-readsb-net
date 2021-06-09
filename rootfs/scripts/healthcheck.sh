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
  # get number of aircraft
  NUM_AIRCRAFT=$(jq '.aircraft | length' < /run/readsb/aircraft.json)
  if [ "$NUM_AIRCRAFT" -lt 1 ]; then
      echo "total aircraft: $NUM_AIRCRAFT. UNHEALTHY"
      EXITCODE=1
  else
      echo "total aircraft: $NUM_AIRCRAFT. HEALTHY"
  fi
else
  echo "WARNING: Cannot find /run/readsb/aircraft.json, so skipping some checks."
fi

# check port 30005 is open
if [ $(netstat -an | grep LISTEN | grep ":30005" | wc -l) -ge 1 ]; then
   echo "TCP port 30005 open. HEALTHY"
else
   echo "TCP port 30005 not open. UNHEALTHY"
   EXITCODE=1
fi

exit $EXITCODE