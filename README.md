# brother-brscan4

Docker image for running Brother `brscan4` and `brscan-skey` inside a container.

This project is meant for network-connected Brother multifunction printers/scanners that can send scan button events to `brscan-skey`. When a scan action is triggered from the device, the container runs a wrapper script and writes the resulting PDF into `/scans`.

The image is published as `jankar/brscan-skey`.

## What It Does

- Installs Brother `brscan4` and `brscan-skey` drivers
- Registers a scanner at container startup using runtime environment variables
- Starts `brscan-skey` and keeps it running
- Maps scanner button actions like `IMAGE` and `OCR` to local scripts
- Saves generated scans into `/scans/<year>/`

This repo is based on `rocketraman/sane-scan-pdf` with local wrapper changes for the Brother workflow.

## Required Environment Variables

These must be set when the container starts:

- `NAME`: friendly scanner name used by Brother tools
- `MODEL`: scanner model, for example `MFC-L2710DW`
- `IPADDRESS`: scanner IP address on your network

The container now applies these values at runtime, so you do not need to rebuild the image for each scanner.

## Volume

- `/scans`: output directory for generated scans

If the scanner triggers a scan successfully, files are written under a year-based folder such as:

```text
/scans/2026/2026-04-28-06-15_image.pdf
```

## Networking

`brscan-skey` has historically worked best with host networking. The image exposes relevant ports, but the primary documented setup still uses `--net=host`.

## Docker Run

Interactive:

```bash
docker run --rm -it \
  --name brscan-skey \
  --net=host \
  -v /home/$USER/scans:/scans \
  -e NAME=Scanner \
  -e MODEL=MFC-L2710DW \
  -e IPADDRESS=192.168.1.207 \
  jankar/brscan-skey:latest
```

Detached:

```bash
docker run -d \
  --name brscan-skey \
  --restart unless-stopped \
  --net=host \
  -v /home/$USER/scans:/scans \
  -e NAME=Scanner \
  -e MODEL=MFC-L2710DW \
  -e IPADDRESS=192.168.1.207 \
  jankar/brscan-skey:latest
```

## Docker Compose

```yaml
services:
  brscan-skey:
    image: jankar/brscan-skey:latest
    container_name: brscan-skey
    network_mode: host
    restart: unless-stopped
    environment:
      NAME: Scanner
      MODEL: MFC-L2710DW
      IPADDRESS: 192.168.1.207
      TZ: America/Chicago
    volumes:
      - /home/your-user/scans:/scans
```

## Startup Behavior

On startup the container:

1. Verifies `NAME`, `MODEL`, and `IPADDRESS` are present
2. Clears any existing Brother scanner registrations in the container
3. Registers the scanner using the runtime values
4. Prints the effective `brsaneconfig4 -q` output to the logs
5. Starts `brscan-skey`

This makes Compose and `docker run` overrides behave the way users expect.

## Logs

To verify the active scanner configuration after startup:

```bash
docker logs brscan-skey
```

You should see lines like:

```text
Configuring scanner with runtime environment variables:
NAME=Scanner
MODEL=MFC-L2710DW
IPADDRESS=192.168.1.207
Effective brsaneconfig4 configuration:
* MFC-L2710DW  [  192.168.1.207]  Scanner
```

## Build Locally

Build the image locally:

```bash
docker build -t local/brscan-skey --build-arg BUILD_VERSION=dev .
```

Run the local build:

```bash
docker run -d \
  --name brscan-skey-dev \
  --net=host \
  -v /home/$USER/scans:/scans \
  -e NAME=Scanner \
  -e MODEL=MFC-L2710DW \
  -e IPADDRESS=192.168.1.207 \
  local/brscan-skey
```

## Notes

- OCR is available through the included scanning workflow
- The default timezone in the image is `America/Chicago`, but you can override `TZ`
- The scanner must be reachable from the container on your local network

