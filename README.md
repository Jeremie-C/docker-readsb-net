# docker-readsb-net

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/jeremiec82/readsb-net?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/jeremiec82/readsb-net?style=plastic)
[![Deploy to Docker Hub](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/deploy.yml/badge.svg)](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/deploy.yml)
[![Check Code](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/check_code.yml/badge.svg)](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/check_code.yml)
[![Docker Build](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/test_build.yml/badge.svg)](https://github.com/Jeremie-C/docker-readsb-net/actions/workflows/test_build.yml)

Mode-S/ADSB/TIS decoder running in a docker container.

## Environment Variables

### Container Options

| Variable | Description | Default |
|----------|-------------|---------|
| `TZ` | Local timezone in ["TZ database name" format](<https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>). | `UTC` |

### `readsb` General Options

Where the default value is "Required", the container not start without it.

Where the default value is "Unset", `readsb`'s default will be used.

| Variable | Description | Controls which `readsb` option | Default |
|----------|-------------|--------------------------------|---------|
| `LAT` | Reference/receiver surface latitude | `--lat=<lat>` | Required |
| `LON` | Reference/receiver surface longitude | `--lon=<lon>` | Required |
| `BEAST_HOST` | IP of remote readsb / dump1090 server | | Required |
| `BEAST_PORT` | Port of remote dump190 server specified as argument `--net-bo-port`' on remote system | | Required |
| `NET_CONNECTOR` | See "`NET_CONNECTOR` syntax" below. | `--net-connector=<ip,port,protocol>` | Unset |
| `NET_CONNECTOR_DELAY` | Outbound re-connection delay. | `--net-connector-delay=<seconds>` | `30` |

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