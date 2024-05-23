#!/bin/bash
/opt/code-server-*-linux-amd64/bin/code-server \
  --extensions-dir $HOME/code-server/extensions \
  --user-data-dir $HOME/code-server/data \
  --config $HOME/code-server/config.yaml \
  --auth none --bind-addr 0.0.0.0:7000 \
  --disable-update-check --disable-telemetry -vvv