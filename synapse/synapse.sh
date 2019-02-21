#!/bin/bash

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir -p ~/.config/synapse/
cp ${currDir}/config.json ~/.config/synapse/config.json -v