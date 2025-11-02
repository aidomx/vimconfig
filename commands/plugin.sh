#!/usr/bin/env bash

# Load plugin modules
for plugin_file in "${VCFG_ROOT}/commands/plugin"/*.sh; do
  source "$plugin_file"
done
