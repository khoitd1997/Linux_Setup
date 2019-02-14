import json
from pathlib import Path
import os

synapseConf = str(Path.home())
synapseConf = os.path.join(synapseConf, '.config/synapse/config.json')

with open(synapseConf, 'r+') as f:
    data = json.load(f)
    # change keybindings to be super
    data['ui']['shortcuts']['activate'] = "Super_L"
    f.seek(0)
    json.dump(data, f, indent=4)
    f.truncate()
