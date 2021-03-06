# docker-readsb-net

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/jeremiec82/readsb-net?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/jeremiec82/readsb-net?style=plastic)
[![Deploy to Docker Hub](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/deploy.yml/badge.svg)](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/deploy.yml)
[![Check Code](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/check_code.yml/badge.svg)](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/check_code.yml)
[![Docker Build](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/test_build.yml/badge.svg)](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/test_build.yml)

Mode-S/ADSB/TIS decoder running in a docker container.

## Ports

| Port | Detail |
| ---- | ------ |
| 30005/tcp | Beast protocol output. Optional. Allow other applications outside docker host to receive the data provided by readsb |
| 30104/tcp | Beast protocol input. Optional. Allow other applications (dump1090, mlat-client) outside docker host to send data to readsb |

## Environment Variables

### Container Options

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `TZ` | Local timezone in ["TZ database name" format](<https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>). | `UTC` |

### `readsb` General Options

Where the default value is "Required", the container not start without it.

Where the default value is "Unset", `readsb`'s default will be used.

| Variable | Description | Controls which `readsb` option | Default |
| -------- | ----------- | ------------------------------ | ------- |
| `LATITUDE` | Reference/receiver surface latitude | `--lat=<lat>` | Required |
| `LONGITUDE` | Reference/receiver surface longitude | `--lon=<lon>` | Required |
| `BEAST_HOST` | IP of remote readsb / dump1090 server | | Required |
| `BEAST_PORT` | Port of remote dump190 server specified as argument `--net-bo-port`' on remote system | | Required |
| `NET_CONNECTOR` | See "`NET_CONNECTOR` syntax" below. | `--net-connector=<ip,port,protocol>` | Unset |
| `NET_CONNECTOR_DELAY` | Outbound re-connection delay. | `--net-connector-delay=<seconds>` | Unset |
| `READSB_JSON_GLOBE` | Write specially indexed globe_xxxx.json files | `--write-json-globe-index` | Unset |
| `READSB_FORWARD_MLAT` | Allow forwarding of received mlat results to output ports | `--forward-mlat` | Unset |

#### `NET_CONNECTOR` syntax

This variable allows you to configure outgoing connections. The variable takes a semicolon (`;`) separated list of `ip,port,protocol`, where:

* `ip` is an IP address. Specify an IP/hostname/containername for outgoing connections.
* `port` is a TCP port number
* `protocol` can be one of the following:
  * `beast_out`: Beast-format output
  * `beast_in`: Beast-format input
  * `raw_out`: Raw output
  * `raw_in`: Raw input
  * `sbs_out`: SBS-format output
  * `vrs_out`: SBS-format output

## Paths & Volumes

| Path in container | Detail |
| ----------------- | ------ |
| /var/readsb | Readsb output files & history. Required if you want to use my Tar1090 container. |
